//
//  AddCategoryView.swift
//  Quebrao
//
//  Created by Francisco Vargas on 2/13/25.
//

import SwiftUI

struct AddCategoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var categoryToEdit : Category?
    
    @State var categoryName : String = ""
    
    var body: some View {
        VStack{
            
            TextField("Category name", text: $categoryName)
                .padding(.leading)
            
            
            Button("Save", action: {})
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .foregroundColor(.white)
        }
        .onAppear() {
            if categoryToEdit != nil {
                categoryName = categoryToEdit!.name!
            }
        }
    }
    
    func addCategory() {
        if categoryName == "" {
            return
        }
        
        if categoryToEdit != nil {
            categoryToEdit?.name = categoryName
        } else {
            let newCategory = Category(context: viewContext)
            newCategory.name = categoryName
            newCategory.categoryId = UUID()
        }
        
        do {
            try viewContext.save()
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    AddCategoryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
