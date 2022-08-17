//
//  Notice.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData

@objc(Posting)
public class Posting: NSManagedObject {
    
    private(set) var headline: String {
        get { headline_! }
        set { headline_ = newValue}
    }
    
    private(set) var content: String {
        get { content_! }
        set { content_ = newValue }
    }
    
    private(set) var userName: String {
        get { userName_! }
        set { userName_ = newValue }
    }
    
    private(set) var creationDate: Date {
        get { creationDate_! }
        set { creationDate_ = newValue }
    }
    
    private(set) var comments: [Comment] {
        get { (comments_ as? Set<Comment>)?.sorted() ?? [] }
        set { comments_ = Set(newValue) as NSSet }
    }
    
    private(set) var keywords: [Keyword] {
        get { (keywords_?.compactMap { Keyword(rawValue: $0) }) ?? [] }
        set { keywords_ = newValue.map { $0.rawValue} }
    }
}

extension Posting: Comparable {
    
    public static func < (lhs: Posting, rhs: Posting) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
}

extension Posting {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Posting> {
        let request = NSFetchRequest<Posting>(entityName: "Posting")
        request.sortDescriptors = [NSSortDescriptor(
            key: "creationDate_",
            ascending: true
        )]
        request.predicate = predicate
        return request
    }
}

extension Posting {
    
    convenience init(
        headline: String,
        content: String,
        userName: String,
        userId: Int64,
        comments: [Comment] = [],
        keywords: [Keyword] = [],
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.creationDate = .now
        self.headline = headline
        self.content = content
        self.userName = userName
        self.userId = userId
        self.comments = []
        self.keywords = keywords
    }
    
    convenience init(
        with data: PostingData,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        if let id = data.id { self.id = id }
        self.headline = data.headline
        self.content = data.content
        self.userName = data.userName
        self.userId = data.userId
        self.creationDate = data.creationDate
        self.comments = data.comments.map {
            Comment(with: $0, for: self, in: context)
        }
    }
}

public enum Keyword: String, CaseIterable {
    case Essen, Sport, Transport, Party, Event, Suche, Biete, Info
}

