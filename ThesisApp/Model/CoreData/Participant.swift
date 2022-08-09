//
//  Participant.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import CoreData

@objc(Participant)
public class Participant: User {
    
    var activities: [Activity] {
        get { (activities_ as? Set<Activity>)?.sorted() ?? [] }
        set { activities_ = Set(newValue) as NSSet }
    }
    
    public convenience init(
        firstName: String,
        lastName: String,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension Participant {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Participant> {
        let request = NSFetchRequest<Participant>(entityName: "Participant")
        request.sortDescriptors = [NSSortDescriptor(key: "firstName_", ascending: true)]
        request.predicate = predicate
        return request
    }
}
