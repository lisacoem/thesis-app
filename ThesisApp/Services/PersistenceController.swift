//
//  Persistence.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.07.22.
//

import CoreData

class PersistenceController {

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "App")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
    
extension PersistenceController {
    
    // instance for production
    static var shared: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    // instance with database drop for development
    static var develop: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        
        result.resetUserData()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // instance for xcode previews with mocked persistence
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
    
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}

extension PersistenceController {

    private func resetRecords(for entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        _ = try? container.viewContext.execute(deleteRequest)
        try? container.viewContext.save()
    }
    
    func resetUserData() {
        resetRecords(for: "Activity")
        resetRecords(for: "TrackPoint")
        resetRecords(for: "User")
        resetRecords(for: "Posting")
        resetRecords(for: "Comment")
        resetRecords(for: "Field")
        resetRecords(for: "Seed")
        resetRecords(for: "Plant")
        resetRecords(for: "Achievement")
    }
}
