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
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories) { category in
                        Text(category.name!).tag(Optional(category))
                    }
                    .onAppear() {
                        selectedCategory = categories[0]
                    }
                }
            }
            
            Button("Save", action: addTransaction)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .foregroundColor(.white)
        }
    }
    
    private func addTransaction() {
        let newTransaction = Transactions(context: viewContext)
        newTransaction.date = date
        newTransaction.amount = amount
        newTransaction.notes = notes
        newTransaction.category = selectedCategory
        newTransaction.income = income
        newTransaction.expenseID = UUID()

        do {
            try viewContext.save()
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    AddTransactionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
