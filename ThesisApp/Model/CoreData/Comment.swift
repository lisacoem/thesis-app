//
//  Comment.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData

@objc(Comment)
public class Comment: NSManagedObject {
    
    var creator: User {
        get { creator_! }
        set { creator_ = newValue }
    }
    
    var content: String {
        get { content_! }
        set { content_ = newValue}
    }
    
    var creationDate: Date {
        get { creationDate_! }
        set { creationDate_ = newValue }
    }
    
    convenience init(content: String, by user: User, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.creationDate = Date.now
        self.content = content
        self.creator = user
    }
}

extension Comment: Comparable {
    
    public static func < (lhs: Comment, rhs: Comment) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
}

extension Comment {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Comment> {
        let request = NSFetchRequest<Comment>(entityName: "Comment")
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate_", ascending: true)]
        request.predicate = predicate
        return request
    }
}

