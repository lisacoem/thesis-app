//
//  Persistence.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import CoreData

struct PersistenceController {

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

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "thesis-app")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    private func seedPreview() {
        
        let testTrack: [TrackPoint] = [
            .init(latitude: 37.3228276, longitude: -122.0327804, in: container.viewContext),
            .init(latitude: 37.3228288, longitude: -122.0349496, in: container.viewContext),
            .init(latitude: 37.3238299, longitude: -122.0349674, in: container.viewContext),
            .init(latitude: 37.323829, longitude: -122.035194, in: container.viewContext),
            .init(latitude: 37.3251303, longitude: -122.0351992, in: container.viewContext),
            .init(latitude: 37.3251238, longitude: -122.0368214, in: container.viewContext),
            .init(latitude: 37.3279341, longitude: -122.0368713, in: container.viewContext),
            .init(latitude: 37.3302164, longitude: -122.0368791, in: container.viewContext),
            .init(latitude: 37.3302274, longitude: -122.0344155, in: container.viewContext),
            .init(latitude: 37.3293615, longitude: -122.0344009, in: container.viewContext),
            .init(latitude: 37.3293635, longitude: -122.0341872, in: container.viewContext),
            .init(latitude: 37.329194, longitude: -122.03339, in: container.viewContext),
            .init(latitude: 37.3289479, longitude: -122.0324014, in: container.viewContext),
            .init(latitude: 37.3253598, longitude: -122.0323979, in: container.viewContext),
            .init(latitude: 37.325136, longitude: -122.0323982, in: container.viewContext),
            .init(latitude: 37.3251328, longitude: -122.0331518, in: container.viewContext),
            .init(latitude: 37.324951, longitude: -122.0331578, in: container.viewContext),
            .init(latitude: 37.3249569, longitude: -122.0343783, in: container.viewContext),
        ]
        
        let users: [User] = [
            .init(firstName: "Anja", lastName: "Müller", in: container.viewContext),
            .init(firstName: "Martin", lastName: "Kemmel", in: container.viewContext)
        ]
        
        for _ in 1...5 {
            let activity = Activity(
                movement: Movement.allCases.randomElement()!,
                distance: Float.random(in: 5..<40),
                date: generateRandomDate(daysBack: 50) ?? .now,
                duration: Double.random(in: 30*60..<5*3600),
                track: testTrack,
                in: container.viewContext
            )
            print(activity)
        }
        
        for i in 1...5 {
            let notice = PinboardEntry(title: "Eintrag \(i)", content: "Lorem Ipsum", creator: users.randomElement()!, keywords: [Keyword.allCases.randomElement()!], creationDate: generateRandomDate(daysBack: 30) ?? .now, in: container.viewContext)
            print(notice)
        }
    }
    
    private func resetRecords(for entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        _ = try? container.viewContext.execute(deleteRequest)
        try? container.viewContext.save()
    }
    
}

func generateRandomDate(daysBack: Int) -> Date?{
    let day = arc4random_uniform(UInt32(daysBack))+1
    let hour = arc4random_uniform(23)
    let minute = arc4random_uniform(59)
    
    let today = Date(timeIntervalSinceNow: 0)
    let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
    var offsetComponents = DateComponents()
    offsetComponents.day = -1 * Int(day - 1)
    offsetComponents.hour = -1 * Int(hour)
    offsetComponents.minute = -1 * Int(minute)
    
    let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
    return randomDate
}
