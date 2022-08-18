//
//  Team.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import CoreData

@objc(Team)
public class Team: NSManagedObject {
    
    private(set) var zipcode: String {
        get { zipcode_! }
        set { zipcode_ = newValue }
    }
    
    private(set) var name: String {
        get { name_! }
        set { name_ = newValue }
    }

}

extension Team: Comparable {
    
    public static func < (lhs: Team, rhs: Team) -> Bool {
        if lhs.zipcode == rhs.zipcode {
            return lhs.name < rhs.name
        }
        return lhs.zipcode < rhs.zipcode
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.zipcode == rhs.zipcode && lhs.name == rhs.name
    }
}

extension Team {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Team> {
        let request = NSFetchRequest<Team>(entityName: "Team")
        request.sortDescriptors = [NSSortDescriptor(key: "zipcode_", ascending: true)]
        request.predicate = predicate
        return request
    }
}

extension Team {
    
    convenience init(with data: TeamData, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = data.id
        self.name = data.name
        self.zipcode = data.zipcode
    }
    
    func update(from data: TeamData) {
        self.name = data.name
        self.zipcode = data.zipcode
    }
}

extension PersistenceController {
    
    func saveTeam(with data: TeamData) {
        let request = Team.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let team = try? container.viewContext.fetch(request).first {
            team.update(from: data)
        } else {
            let team = Team(with: data, in: container.viewContext)
            print("saved new team: \(team.zipcode) \(team.name)")
        }
        try? container.viewContext.save()
    }
    
    func getTeam(with data: TeamData) -> Team {
        let request = Team.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let team = try? container.viewContext.fetch(request).first {
            return team
        }
        
        let team = Team(with: data, in: container.viewContext)
        try? container.viewContext.save()
        return team
    }
}
