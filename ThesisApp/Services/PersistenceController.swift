//
//  Persistence.swift
//  thesis-app
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
    
    static var shared: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        
        result.resetRecords(for: "User")
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        result.seedPreview()
    
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
}

extension PersistenceController {
    
    private func seedPreview() {
        for _ in 1...5 {
            let _ = Activity(
                movement: Movement.allCases.randomElement()!,
                distance: Double.random(in: 5..<40),
                duration: Double.random(in: 30*60..<5*3600),
                track: [],
                in: container.viewContext
            )
        }
        
        /*for i in 1...5 {
            let _ = Posting(
                headline: "Eintrag \(i)",
                content: "Lorem Ipsum",
                userName: "Anja M",
                userId: 1,
                keywords: [Keyword.allCases.randomElement()!],
                in: container.viewContext
            )
        }*/
    }
}

