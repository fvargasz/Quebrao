//
//  CalerdarHelper.swift
//  Quebrao
//
//  Created by Francisco Vargas on 2/5/25.
//

import Foundation

class CalendarHelper {
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    func monthYearString(_ date: Date) -> String
    {
        dateFormatter.dateFormat = "LLL yyyy"
        return dateFormatter.string(from: date)
    }
    
    func plusMonth(_ date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(_ date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func currentMonth(_ date: Date) -> Int {
        return 0
    }
}
