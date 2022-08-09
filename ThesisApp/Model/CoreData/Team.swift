//
//  Team.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation
import CoreData

@objc(Team)
public class Team: NSManagedObject {
    
    var zipcode: String {
        get { zipcode_! }
        set { zipcode_ = newValue }
    }
    
    var city: String {
        get { city_! }
        set { city_ = newValue }
    }
    
    var participants: [Participant] {
        get { (participants_ as? Set<Participant>)?.sorted() ?? [] }
        set { participants_ = Set(newValue) as NSSet }
    }
}

extension Participant {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Team> {
        let request = NSFetchRequest<Team>(entityName: "Team")
        request.sortDescriptors = [NSSortDescriptor(key: "zipcode_", ascending: true)]
        request.predicate = predicate
        return request
    }
}
