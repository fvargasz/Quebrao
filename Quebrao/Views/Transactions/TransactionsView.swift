//
//  TransactionsView.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/4/24.
//

import SwiftUI

struct TransactionsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transactions.date, ascending: true)],
        animation: .default)
    private var transactions: FetchedResults<Transactions>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(transactions) { item in
                        NavigationLink (destination: TransactionDetailView(transaction: item), label: {
                            Text("\(item.amount, specifier: "%.2f") \(item.category?.name ?? "Uknown)")")
                        })
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        AddTransactionView()
                    } label: {
                        Label("", systemImage: "plus")
                    }
                }
            }
            .padding()
            .onAppear {
                
                /*for tran in transactions {
                    viewContext.delete(tran)
                }
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }*/
            }
        }
    }
    
}

#Preview {
    TransactionsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

