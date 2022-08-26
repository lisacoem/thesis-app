//
//  Field.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation
import CoreData

@objc(Field)
public class Field: NSManagedObject {

    fileprivate(set) var name: String {
        get { name_! }
        set { name_ = newValue }
    }
    
    fileprivate(set) var street: String {
        get { street_! }
        set { street_ = newValue }
    }
    
    fileprivate(set) var plants: Set<Plant> {
        get { plants_ as? Set ?? [] }
        set { plants_ = newValue as NSSet }
    }
    
    fileprivate(set) var seeds: Set<Seed> {
        get { seeds_ as? Set ?? [] }
        set { seeds_ = newValue as NSSet }
    }
    
    convenience init(
        id: Int64,
        name: String,
        street: String,
        plants: Set<Plant> = [],
        seeds: Set<Seed> = [],
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.street = street
        self.plants = plants
        self.seeds = seeds
    }

}

extension Field {
    
    static func == (lhs: Field, rhs: Field) -> Bool {
        lhs.id == rhs.id
    }
}

extension Field {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Field> {
        let request = NSFetchRequest<Field>(entityName: "Field")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        return request
    }
}
