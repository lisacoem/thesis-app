//
//  Comment.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData

@objc(Comment)
public class Comment: NSManagedObject {
    
    fileprivate(set) var userName: String {
        get { userName_! }
        set { userName_ = newValue }
    }
    
    fileprivate(set) var content: String {
        get { content_! }
        set { content_ = newValue}
    }
    
    fileprivate(set) var creationDate: Date {
        get { creationDate_! }
        set { creationDate_ = newValue.formatted ?? newValue }
    }
    
    fileprivate(set) var posting: Posting {
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
        with data: CommentResponseData,
        for posting: Posting,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = data.id
        self.content = data.content
        self.creationDate = data.creationDate
        self.userName = data.userName
        self.userId = data.userId
        self.posting = posting
    }
    
    func update(with data: CommentResponseData) {
        self.content = content
    }
}

extension PersistenceController {

    func saveComment(with data: CommentResponseData, for posting: Posting) {
        let request = Comment.fetchRequest(NSPredicate(format: "id == %i", data.id))
        
        if let comment = try? container.viewContext.fetch(request).first {
            comment.content = data.content
        } else {
            let comment = Comment(with: data, for: posting, in: container.viewContext)
            print("new comment: (\(comment.id)) \(comment.content) from \(comment.userName)")
        }
        try? container.viewContext.save()
    }
    
    func getComment(with data: CommentResponseData, for posting: Posting) -> Comment {
        let request = Comment.fetchRequest(NSPredicate(format: "id == %i", data.id))
        
        if let comment = try? container.viewContext.fetch(request).first {
            comment.content = data.content
            try? container.viewContext.save()
            return comment
        }
        
        let comment = Comment(with: data, for: posting, in: container.viewContext)
        print("new comment: (\(comment.id)) \(comment.content) from \(comment.userName)")
        try? container.viewContext.save()
        return comment
    }
}
