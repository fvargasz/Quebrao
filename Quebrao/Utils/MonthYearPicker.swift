//
//  MonthYearPicker.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/8/24.
//

import SwiftUI

struct MonthYearPicker : View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder : DateHolder
    let onDateChanged:() -> Void

    var body : some View {
        HStack
        {
            Spacer()
            Button(action: previousMonth)
            {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
                
            }
            Text(CalendarHelper().monthYearString(dateHolder.date))
                .font(Fonts.title)
                .bold()
                .animation(.none)
                .frame(maxWidth: .infinity)
            Button(action: nextMonth)
            {
                Image(systemName: "chevron.right")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
            Spacer()
        }
    }
    func previousMonth()
        {
            dateHolder.date = CalendarHelper().minusMonth(dateHolder.date)
            dateHolder.refreshTaskItems(viewContext)
            onDateChanged()
        }
        
        func nextMonth()
        {
            dateHolder.date = CalendarHelper().plusMonth(dateHolder.date)
            dateHolder.refreshTaskItems(viewContext)
            onDateChanged()
        }
}

struct MonthYearPicker_Previews : PreviewProvider {
    static var previews: some View {
        MonthYearPicker(onDateChanged: {})
            .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
    }
}
