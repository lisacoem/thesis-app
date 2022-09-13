//
//  Achievement.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 13.09.22.
//

import Foundation
import CoreData

@objc(Achievement)
public class Achievement: NSManagedObject {
    
    fileprivate(set) var title: String {
        get { title_! }
        set { title_ = newValue }
    }
    
    fileprivate(set) var content: String {
        get { content_! }
        set { content_ = newValue }
    }
}

extension Achievement {
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Achievement> {
        let request = NSFetchRequest<Achievement>(entityName: "Achievement")
        request.sortDescriptors = [NSSortDescriptor(key: "progress", ascending: true)]
        request.predicate = predicate
        return request
    }
}

extension Achievement {
    
    fileprivate convenience init(with data: AchievementData, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = data.title
        self.content = data.content
        self.goal = data.goal
        self.unlocked = data.unlocked
    }
}

extension PersistenceController {
    
    func save(with data: AchievementData) -> Achievement {
        let predicate = NSPredicate(format: "id == %i", data.id)
        let request = Achievement.fetchRequest(predicate)
        if let achievement = try? container.viewContext.fetch(request).first {
            return update(achievement, with: data)
        }
        return create(with: data)
    }
    
    func update(_ achievement: Achievement, with data: AchievementData) -> Achievement {
        achievement.title = data.title
        achievement.content = data.content
        achievement.goal = data.goal
        achievement.unlocked = data.unlocked
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return achievement
    }
    
    func create(with data: AchievementData) -> Achievement {
        let achievement = Achievement(with: data, in: container.viewContext)
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return achievement
    }
}
