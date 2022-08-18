//
//  Comment.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData

@objc(Comment)
public class Comment: NSManagedObject {
    
    private(set) var userName: String {
        get { userName_! }
        set { userName_ = newValue }
    }
    
    private(set) var content: String {
        get { content_! }
        set { content_ = newValue}
    }
    
    private(set) var creationDate: Date {
        get { creationDate_! }
        set { creationDate_ = newValue.formatted ?? newValue }
    }
    
    private(set) var posting: Posting {
        get { posting_! }
        set { posting_ = newValue }
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
        request.sortDescriptors = [NSSortDescriptor(
            key: "creationDate_",
            ascending: true
        )]
        request.predicate = predicate
        return request
    }
}

extension Comment {
    
    convenience init(
        content: String,
        by user: User,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.creationDate = Date.now
        self.content = content
        self.userName = user.friendlyName
        self.userId = user.id
    }
    
    convenience init(
        with data: CommentData,
        for posting: Posting,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = data.id
        self.content = data.content
        self.userName = data.userName
        self.userId = data.userId
        self.posting = posting
    }
    
    func update(with data: CommentData) {
        self.content = content
    }
}
