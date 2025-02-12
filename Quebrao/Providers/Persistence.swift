//
//  Persistence.swift
//  Quebrao
//
//  Created by Francisco Vargas on 8/4/24.
//

import CoreData

class PersistenceController : ObservableObject {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let categories = ["Ocio", "Inversion", "Renta", "Telefono", "Gym",
        "Ropa", "Transporte", "Carro", "Gasolina", "Take out",
        "Comida", "Streaming", "Medicina", "Higiene/Cosmeticos", "Agua",
        "Muebles", "Electricidad", "Musica"]
        
        var listedCategories : [Category] = []
        
        for category in categories {
            let newCategory = Category(context: viewContext)
            newCategory.name = category
            newCategory.categoryId = UUID()
            listedCategories.append(newCategory)
        }
        
        for i in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            let newTransaction = Transactions(context: viewContext)
            newTransaction.date = Date()
            newTransaction.amount = 1000
            newTransaction.category = listedCategories[i]
            newTransaction.income = false
            newTransaction.notes = ""
            newTransaction.expenseID = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Quebrao")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error.description), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        LoadData()
    }
    
    func LoadData() {
        let viewContext = container.viewContext
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        let categories = ["Ocio", "Inversion", "Renta", "Telefono", "Gym",
        "Ropa", "Transporte", "Carro", "Gasolina", "Take out",
        "Comida", "Streaming", "Medicina", "Higiene/Cosmeticos", "Agua",
        "Muebles", "Electricidad", "Musica"]
        
        do {
                let existingCategories = try viewContext.fetch(fetchRequest)
                var existingCategoryNames = Set(existingCategories.map { $0.name ?? "" })
                
                for category in categories {
                    if !existingCategoryNames.contains(category) {
                        let newCategory = Category(context: viewContext)
                        newCategory.name = category
                        newCategory.categoryId = UUID()
                        existingCategoryNames.insert(category)
                    }
                }
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
