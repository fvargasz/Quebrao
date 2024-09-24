//
//  QuebraoApp.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/4/24.
//

import SwiftUI
@main
struct QuebraoApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
