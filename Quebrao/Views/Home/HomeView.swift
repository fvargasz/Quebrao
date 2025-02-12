//
//  HomeView.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/4/24.
//

import SwiftUI
import Charts

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder

    //@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Transactions.date, ascending: true)],animation: .default) private var transactions: FetchedResults<Transactions>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    @State var data : [CategoryExpense] = []
    @State var totalAmountExpenses : Double = 0.00
    @State var netBalance : String = ""
    @State var anyExpense = false

    var body: some View {
        VStack{
            
            MonthYearPicker() {
                loadGraphData()
            }
                .environmentObject(dateHolder)
                .padding()
            

            Text("Balance").font(Fonts.title).padding(.top, 20)
            Text(netBalance).font(Fonts.title)
        
            if (!anyExpense) {
                Text("No gastaste nada este mes!")
            }
            
            Chart (data, id: \.type) { dataItem in
                SectorMark(angle: .value("Type", dataItem.amount))
                    .foregroundStyle(
                        by: .value(
                            Text(verbatim: dataItem.type),
                            dataItem.type
                        )
                    )
            }
            .frame(height: 300)
            .padding()
            
            List {
                ForEach(data) { item in
                    HStack {
                        Text(item.type)
                        Spacer()
                        Text("\(item.amount, specifier: "%.2f") ")
                        Text("\((item.amount * 100) / totalAmountExpenses, specifier: "%.2f")%")
                    }
                }
            }
        }
        .onAppear() {
            loadGraphData()
        }
    }
    
    func loadGraphData() {
        data = []
        self.totalAmountExpenses = 0.00
        anyExpense = false
        
        var totalAmountExpenses : Double = 0.00
        var totalAmountIncome : Double = 0.00
        
        let transactionsDone = dateHolder.fetchTransactions(viewContext)
        
        var expenses: [String:Double] = [:]
        
        for transaction in transactionsDone {
            if transaction.income == false {
                
                totalAmountExpenses = totalAmountExpenses + transaction.amount
                let categoryName = transaction.category?.name
                anyExpense = true
                if expenses.keys.contains(categoryName!) {
                    expenses[categoryName!]! += transaction.amount
                } else {
                    expenses[categoryName!] = transaction.amount
                }
                
            } else {
                totalAmountIncome = totalAmountIncome + transaction.amount
            }
        }
        
        netBalance = String(format: "%.2f", totalAmountIncome - totalAmountExpenses)
        
        for (category, amount) in expenses {
            if amount > 0.0 {
                let newItem = CategoryExpense(type: category, amount: amount)
                data.append(newItem)
            }
            self.totalAmountExpenses = totalAmountExpenses
        }
    }
}

#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
}
