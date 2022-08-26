//
//  Notice.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData

@objc(Posting)
public class Posting: NSManagedObject {
    
    fileprivate(set) var headline: String {
        get { headline_! }
        set { headline_ = newValue}
    }
    
    fileprivate(set) var content: String {
        get { content_! }
        set { content_ = newValue }
    }
    
    fileprivate(set) var creator: User {
        get { creator_! }
        set { creator_ = newValue }
    }
    
    fileprivate(set) var creationDate: Date {
        get { creationDate_! }
        set { creationDate_ = newValue.formatted ?? newValue }
    }
    
    fileprivate(set) var keywords: [Keyword] {
        get { (keywords_?.compactMap { Keyword(rawValue: $0) }) ?? [] }
        set { keywords_ = newValue.map { $0.rawValue} }
    }
    
    fileprivate(set) var comments: [Comment] {
        get { (comments_ as? Set<Comment>)?.sorted() ?? [] }
        set { comments_ = Set(newValue) as NSSet }
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
        with data: PostingResponseData,
        by creator: User,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = data.id
        self.headline = data.headline
        self.content = data.content
        self.creationDate = data.creationDate
        self.creator = creator
        self.keywords = data.keywords.compactMap { Keyword(rawValue: $0) }
    }
    
    func update(with data: PostingResponseData) {
        self.content = content
    }
}

extension PersistenceController {

    func savePosting(with data: PostingResponseData) {
        let request = Posting.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let posting = try? container.viewContext.fetch(request).first {
            print("found existing posting: \(posting.headline)")
            posting.content = data.content
            posting.comments = data.comments.map {
                self.getComment(with: $0, for: posting)
            }
            
            try? container.viewContext.save()
            return
        }
        
        let creator = getUser(with: data.creator)
        let posting = Posting(with: data, by: creator, in: container.viewContext)
        
        posting.comments = data.comments.map {
            Comment(
                with: $0,
                for: posting,
                by: self.getUser(with: $0.creator),
                in: container.viewContext
            )
        }
        
        do {
            try container.viewContext.save()
            print("saved new posting: \(posting.headline)")
        } catch {
            print(error)
            print("failed on posting: \(posting.headline)")
        }
    }
}

