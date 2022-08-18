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
    
    private(set) var points: Double {
        get { points_ }
        set { points_ = newValue.rounded(digits: 2)}
    }

    private(set) var firstName: String {
        get { firstName_! }
        set { firstName_ = newValue }
    }
    
    private(set) var lastName: String {
        get { lastName_! }
        set { lastName_ = newValue }
    }
    
    private(set) var role: Role {
        get { Role(rawValue: role_!)! }
        set { role_ = newValue.rawValue }
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
    
    convenience init(with data: UserData, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = data.id
        self.firstName = data.firstName
        self.lastName = data.lastName
        self.role = data.role
        self.points = data.points
        if let teamData = data.team {
            self.team = Team(with: teamData, in: context)
        }
    }
    
    func update(with data: UserData) {
        self.firstName = data.firstName
        self.lastName = data.lastName
        self.role = data.role
        self.points = data.points
    }
}

extension PersistenceController {
    
    func saveUser(with data: UserData) -> User {
        let request = User.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let user = try? container.viewContext.fetch(request).first {
            print(user.friendlyName)
            user.update(with: data)
            if let teamData = data.team {
                let team = getTeam(with: teamData)
                user.team = team
            } else {
                user.team = nil
            }
            try? container.viewContext.save()
            return user
        }
        let user = User(with: data, in: container.viewContext)
        print("saved new user: \(user.friendlyName)")
        return user 
    }
}
