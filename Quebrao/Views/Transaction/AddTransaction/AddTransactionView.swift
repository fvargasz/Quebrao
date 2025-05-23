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
    
    var transactionToEdit : Transactions?
    var onFinishEdit: () -> Void
    
    var body: some View {

        VStack{
            
            TextField("Amount", text: $amountText)
                .keyboardType(.decimalPad)
                .onChange(of: amountText ) { _, newValue in
                    if let newAmount = Double(newValue) {
                        amount = newAmount
                    } else if newValue.isEmpty {
                        amount = 0.0
                    }
                }
                .padding(.leading)
            
            DatePicker(selection: $date, label: { Text("Date done") })
                .padding(.leading)
                .padding(.trailing)
            
            TextField("Notes", text: $notes)
                .padding(.leading)
                .padding(.trailing)
            
            
            Toggle(isOn: $income) {
                Text("Income or expense")
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
            
            Button("Save", action: addTransaction)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .foregroundColor(.white)
        }
        .onAppear {
            selectedCategory = categories[0]
            if transactionToEdit != nil {
                amount = transactionToEdit!.amount
                amountText = String(format: "%.2f", transactionToEdit!.amount)
                notes = transactionToEdit!.notes ?? ""
                date = transactionToEdit!.date ?? Date()
                income = transactionToEdit!.income
            }
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
