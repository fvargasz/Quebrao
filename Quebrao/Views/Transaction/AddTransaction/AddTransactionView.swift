//
//  AddTransactionView.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/5/24.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var amount : Double = 0
    @State var amountText : String = ""
    @State var notes : String = ""
    @State var date : Date = Date()
    @State var income : Bool = false
    
    @State var selectedCategory: Category?
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var transactionToEdit : Transactions?
    var onFinishEdit: () -> Void
    
    var body: some View {

        VStack{
            
            TextField(String(localized: "Amount", comment: "Placeholder text for transaction amount"), text: $amountText)
                .keyboardType(.decimalPad)
                .onChange(of: amountText ) { _, newValue in
                    if let newAmount = Double(newValue) {
                        amount = newAmount
                    } else if newValue.isEmpty {
                        amount = 0.0
                    }
                }
                .padding(.leading)
            
            DatePicker(selection: $date, label: { Text("Date done", comment: "Signal the user to input the date that the transaction was made") })
                .padding(.leading)
                .padding(.trailing)
            
            TextField(String(localized: "Notes", comment: "Placeholder text for transaction notes"), text: $notes)
                .padding(.leading)
                .padding(.trailing)
            
            
            Toggle(isOn: $income) {
                Text(income ? "Income" : "Expense")
            }
            .padding(.leading)
            .padding(.trailing)
            HStack {
                Spacer()
                if selectedCategory != nil{
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories) { category in
                            Text(category.name!).tag(Optional(category))
                        }
                    }
                } else {
                    ProgressView("Loading categories…")
                }
            }
            
            Button(String(localized: "Save", comment: "Word to indicate the user to save an entity/object"), action: addTransaction)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .foregroundColor(.white)
        }
        .onAppear {
            if categories.isEmpty {
                alertMessage = "There is no category yet. Please add one first."
                showAlert = true
                return
            }
            
            selectedCategory = categories[0]
            if transactionToEdit != nil {
                amount = transactionToEdit!.amount
                amountText = String(format: "%.2f", transactionToEdit!.amount)
                notes = transactionToEdit!.notes ?? ""
                date = transactionToEdit!.date ?? Date()
                income = transactionToEdit!.income
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(String(format: NSLocalizedString("Error", comment: ""))),
                message: Text(alertMessage),
                dismissButton: .default(Text(String(format: NSLocalizedString("OK", comment: "")))) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
        
    }
    
    private func addTransaction() {
        if transactionToEdit != nil {
            transactionToEdit!.date = date
            transactionToEdit!.amount = amount
            transactionToEdit!.notes = notes
            transactionToEdit!.category = selectedCategory
            transactionToEdit!.income = income

        }
        else {
            let newTransaction = Transactions(context: viewContext)
            newTransaction.date = date
            newTransaction.amount = amount
            newTransaction.notes = notes
            newTransaction.category = selectedCategory
            newTransaction.income = income
            newTransaction.expenseID = UUID()
        }
        do {
            try viewContext.save()
            self.presentationMode.wrappedValue.dismiss()
            onFinishEdit()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    AddTransactionView(onFinishEdit: {}).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
