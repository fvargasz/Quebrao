//
//  TransactionsView.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/4/24.
//

import SwiftUI

struct TransactionsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(dateHolder.transactionsDone, id: \.self) { item in
                        NavigationLink (destination: AddTransactionView(transactionToEdit: item, onFinishEdit: loadTransactions), label: {
                            Text("\(item.amount, specifier: "%.2f") \(item.category?.name ?? "Uknown)")")
                        })
                    }.onDelete(perform: { indexSet in
                        for index in indexSet {
                            let item = dateHolder.transactionsDone[index]
                            let id = item.expenseID
                            
                            do {
                                let request = Transactions.fetchRequest()
                                let predicate = NSPredicate(format: "expenseID == %@", id! as CVarArg)
                                
                                request.predicate = predicate
                            
                            
                                let results = try viewContext.fetch(request)
                                if let transaction = results.first {
                                    viewContext.delete(transaction)
                                    try viewContext.save()
                                    dateHolder.transactionsDone.remove(at: index)
                                }
                                
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                            
                        }
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        AddTransactionView(onFinishEdit: loadTransactions)
                            .onDisappear {
                                loadTransactions()
                            }
                    } label: {
                        Label("", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                loadTransactions()
            }
        }
    }
    func loadTransactions() {
        dateHolder.refreshTaskItems(viewContext)
    }
    
    func deleteTransaction (at offsets: IndexSet) {
        
    }
}

#Preview {
    TransactionsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
}

