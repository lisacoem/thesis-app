//
//  User.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    var firstName: String {
        get { firstName_! }
        set { firstName_ = newValue }
    }
    
    var lastName: String {
        get { lastName_! }
        set { lastName_ = newValue }
    }
    
    var friendlyName: String {
        "\(firstName) \(lastName.prefix(1))."
    }
    
    var activities: [Activity] {
        get { (activities_ as? Set<Activity>)?.sorted() ?? [] }
        set { activities_ = Set(newValue) as NSSet }
    }
    
    var postings: [Posting] {
        get { (postings_ as? Set<Posting>)?.sorted() ?? [] }
        set { postings_ = Set(newValue) as NSSet }
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

extension User: Comparable {
    
    public static func < (lhs: User, rhs: User) -> Bool {
        if lhs.firstName == rhs.firstName {
            return lhs.lastName < rhs.lastName
        }
        return lhs.firstName < rhs.firstName
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName
    }
}

extension User {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<User> {
        let request = NSFetchRequest<User>(entityName: "User")
        request.sortDescriptors = [NSSortDescriptor(key: "firstName_", ascending: true)]
        request.predicate = predicate
        return request
    }
}
