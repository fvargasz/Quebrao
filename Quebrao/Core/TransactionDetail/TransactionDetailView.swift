//
//  TransactionDetailView.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/7/24.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    @ObservedObject var transaction : Transactions
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var amountText : String = ""
    @State var notes : String = ""
    @State var date : Date = Date()
    @State var income : Bool = false
    
    @State var selectedCategory: Category?
    
    var body: some View {
        VStack {
            TextField("Amount", text: $amountText)
                            .keyboardType(.decimalPad)
                            .padding()
                            .onChange(of: amountText, initial: true) { _ , newValue  in
                                if let newAmount = Double(newValue) {
                                    transaction.amount = newAmount
                                }
                            }
                            .onAppear {
                                amountText = String(format: "%.2f", transaction.amount)
                            }
            DatePicker(selection: $date, label: { Text("Date done") })
                .onAppear {
                    date = transaction.date ?? Date()
                }
                .onChange(of: date) {
                    _, newValue in
                    transaction.date = newValue
                }
                .padding(.leading)
                .padding(.trailing)
            
            TextField("Notes", text: $notes)
                .onAppear {
                    notes = transaction.notes ?? ""
                }
                .onChange(of: notes, initial: true) {
                    _, newValue in
                    transaction.notes = newValue
                }
                .padding(.leading)
                .padding(.trailing)
            
            
            Toggle(isOn: $income) {
                Text("Income or expense")
            }
            .onAppear() {
                income = transaction.income
            }
            .onChange(of: income) {
                _, newValue in
                transaction.income = newValue
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
                        selectedCategory = categories.first(where: {$0.name == transaction.category?.name}) ?? categories[0]
                    }
                    .onChange(of: selectedCategory) {
                        _, newValue in
                        transaction.category = selectedCategory
                    }
                }
            }
            
            Button("Save", action: updateTransaction)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .foregroundColor(.white)
        }
    }
    private func updateTransaction() {
        
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
    let context = PersistenceController.preview.container.viewContext
    
    // Create a sample Transactions object
    let sampleTransaction = Transactions(context: context)
    sampleTransaction.amount = 1000.45
    sampleTransaction.date = Date()
    sampleTransaction.notes = "Lorem ipsum"
    
    let sampleCategory = Category(context: context)
    sampleCategory.name = "Ocio"
    
    sampleTransaction.category = sampleCategory
    
    return TransactionDetailView(transaction: sampleTransaction)
        .environment(\.managedObjectContext, context)
}
