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
                Text("Home", comment: "Label for Home page icon in tab bar")
            } }
            
            TransactionsView().tabItem { VStack {
                Image(systemName: "list.bullet")
                Text("Trasactions", comment: "Label for Trasactions page icon in tab bar")
            } }
            
            CategoryListView().tabItem { VStack {
                Image(systemName: "folder")
                Text("Categories", comment: "Label for Categories page icon in tab bar")
            } }
        }
    }
}

#Preview {
    MainTabView()
}
