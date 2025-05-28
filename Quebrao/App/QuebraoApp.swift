//
//  QuebraoApp.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/4/24.
//

import SwiftUI
@main
struct QuebraoApp: App {
    @StateObject private var persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let dateHolder = DateHolder(context)
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dateHolder)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
