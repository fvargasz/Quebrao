//
//  MainTabView.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/4/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { VStack {
                Image(systemName: "chart.pie.fill")
                Text("Home")
            } }
            
            TransactionsView().tabItem { VStack {
                Image(systemName: "list.bullet")
                Text("Transactions")
            } }
            
            CategoryListView().tabItem { VStack {
                Image(systemName: "folder")
                Text("Categories")
            } }
        }
    }
}

#Preview {
    MainTabView()
}
