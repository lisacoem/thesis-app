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

    fileprivate(set) var firstName: String {
        get { firstName_! }
        set { firstName_ = newValue }
    }
    
    fileprivate(set) var lastName: String {
        get { lastName_! }
        set { lastName_ = newValue }
    }
    
    var friendlyName: String {
        "\(firstName) \(lastName.prefix(1))."
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
        lhs.id == rhs.id
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

extension User {
    
    fileprivate convenience init(with data: UserData, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = data.id
        self.firstName = data.firstName
        self.lastName = data.lastName
    }
}

extension PersistenceController {
    
    func getUser(with data: UserData) -> User {
        let request = User.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let user = try? container.viewContext.fetch(request).first {
            user.firstName = data.firstName
            user.lastName = data.lastName
            try? container.viewContext.save()
            return user
        }
        
        let user = User(with: data, in: container.viewContext)
        do {
            try container.viewContext.save()
            print("saved new user \(user.friendlyName)")
        } catch {
            print(error)
            print("failed on user \(user.friendlyName)")
        }
        return user
    }
}
