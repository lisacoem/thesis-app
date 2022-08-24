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
    
    fileprivate(set) var city: String {
        get { city_! }
        set { city_ = newValue }
    }
    
    fileprivate(set) var zipcode: String {
        get { zipcode_! }
        set { zipcode_ = newValue }
    }
    
    fileprivate(set) var street: String {
        get { street_! }
        set { street_ = newValue }
    }
}

extension Field: Comparable {
    
    public static func < (lhs: Field, rhs: Field) -> Bool {
        lhs.zipcode < rhs.zipcode
    }
    
    static func == (lhs: Field, rhs: Field) -> Bool {
        lhs.id == rhs.id
    }
}

extension Field {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Field> {
        let request = NSFetchRequest<Field>(entityName: "Field")
        request.sortDescriptors = [NSSortDescriptor(key: "zipcode_", ascending: true)]
        request.predicate = predicate
        return request
    }
}
