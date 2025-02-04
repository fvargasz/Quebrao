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

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transactions.date, ascending: true)],
        animation: .default)
    private var transactions: FetchedResults<Transactions>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    @State var data : [DataItem] = []
    @State var totalAmountExpenses : Double = 0.00
    @State var totalAmountIncome : Double = 0.00
    
    var body: some View {
        VStack{
            Text("Balance").font(Fonts.title).padding(.top, 20)
            Text("\(totalAmountIncome - totalAmountExpenses, specifier: "%.2f")").font(Fonts.title)
        
            
            
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
            
            data = []
            self.totalAmountIncome = 0.00
            self.totalAmountExpenses = 0.00
            
            var totalAmountExpenses : Double = 0.00
            var totalAmountIncome : Double = 0.00
            
            let calendar = Calendar.current

            // Get the current date's month
            let currentMonth = calendar.component(.month, from: Date())
            
            for category in categories {
                var amount : Double = 0.0
                
                for transaction in transactions {
                
                    // Get the month of the provided date
                    let dateMonth = calendar.component(.month, from: transaction.date!)
                        
                    // Compare the two months
                    if (currentMonth != dateMonth) {
                        break
                    }
                    
                    if (transaction.income == false && transaction.category?.name == category.name) {
                        amount = amount + transaction.amount
                        totalAmountExpenses += transaction.amount
                    }
                    else if transaction.income == true {
                        totalAmountIncome += transaction.amount
                    }
                }
                
                if amount > 0.0 {
                    let newItem = DataItem(type: category.name!, amount: amount)
                    data.append(newItem)
                }
                self.totalAmountExpenses = totalAmountExpenses
                self.totalAmountIncome = totalAmountIncome
            }
        }
    }
}

struct DataItem: Identifiable {
    let id = UUID()
    let type: String
    let amount: Double
}

#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
