//
//  DateHolder.swift
//  Quebrao
//
//  Created by Francisco Vargas on 2/5/25.
//

import SwiftUI
import CoreData

class DateHolder: ObservableObject
{
    @Published var date = Date() //todays date
    @Published var transactionsDone : [Transactions] = []
    
    let calendar: Calendar = Calendar.current
    
    init (_ context: NSManagedObjectContext) {
        refreshTaskItems(context)
    }
    
    func refreshTaskItems(_ context: NSManagedObjectContext)
    {
        transactionsDone = fetchTransactions(context)
    }
    
    func monthlyTransactionsRequest() -> NSFetchRequest<Transactions> {
        let request = Transactions.fetchRequest()
        request.predicate = predicate()
        
        return request
    }
    
    func predicate() -> NSPredicate {
        
        let calendar = Calendar.current
        let selectedMonth = calendar.component(.month, from: date)
        let selectedYear = calendar.component(.year, from: date)
        
        var components = DateComponents()
        components.month = selectedMonth
        components.year = selectedYear
        let startDateOfMonth = calendar.date(from: components)
        
        var oneMonth = DateComponents()
        oneMonth.month = 1
        let endDateOfMonth = calendar.date(byAdding: oneMonth, to: startDateOfMonth!)
        
        return NSPredicate(format: "%K >= %@ && %K < %@", "date",startDateOfMonth! as NSDate, "date",endDateOfMonth! as NSDate)
                            
    }
    
    func fetchTransactions(_ context: NSManagedObjectContext) -> [Transactions] {
        do {
            return try context.fetch(monthlyTransactionsRequest())
        } catch {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
        }
    }
    
}
