//
//  Notice.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData

@objc(Posting)
public class Posting: NSManagedObject {
    
    var headline: String {
        get { headline_! }
        set { headline_ = newValue}
    }
    
    var content: String {
        get { content_! }
        set { content_ = newValue }
    }
    
    var creator: User {
        get { creator_! }
        set { creator_ = newValue }
    }
    
    var creationDate: Date {
        get { creationDate_! }
        set { creationDate_ = newValue }
    }
    
    var comments: [Comment] {
        get { (comments_ as? Set<Comment>)?.sorted() ?? [] }
        set { comments_ = Set(newValue) as NSSet }
    }
    
    var keywords: [Keyword] {
        get { (keywords_?.compactMap { Keyword(rawValue: $0) }) ?? [] }
        set { keywords_ = newValue.map { $0.rawValue} }
    }
    
    public convenience init(
        title: String,
        content: String,
        creator: User,
        comments: [Comment] = [],
        keywords: [Keyword] = [],
        creationDate: Date = .now,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.creationDate = creationDate
        self.headline = title
        self.content = content
        self.creator = creator
        self.comments = comments
        self.keywords = keywords
    }
}

extension Posting: Comparable {
    
    public static func < (lhs: Posting, rhs: Posting) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
}

extension Posting {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Posting> {
        let request = NSFetchRequest<Posting>(entityName: "Notice")
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate_", ascending: true)]
        request.predicate = predicate
        return request
    }
}

public enum Keyword: String, CaseIterable {
    case Essen, Sport, Transport, Party, Event, Suche, Biete, Info
}

