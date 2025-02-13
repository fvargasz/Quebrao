//
//  CategoryListView.swift
//  Quebrao
//
//  Created by Francisco Vargas on 2/13/25.
//

import SwiftUI

struct CategoryListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    @State var amount : Double = 0
    @State var amountText : String = ""
    @State var notes : String = ""
    @State var date : Date = Date()
    @State var income : Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(categories) { category in
                        NavigationLink{
                            AddCategoryView(categoryToEdit : category)
                        }
                        label: {
                            Text(category.name ?? "No Name")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        AddCategoryView()
                    } label: {
                        Label("", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
