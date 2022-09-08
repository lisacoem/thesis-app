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
    
    func isCreator(_ userId: Int) -> Bool {
        creator.id == Int64(userId)
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
        self.keywords = data.keywords
    }
}

extension PersistenceController {

    func save(with data: PostingResponseData) -> Posting {
        let request = Posting.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let posting = try? container.viewContext.fetch(request).first {
            return update(posting, with: data)
        }
        return create(with: data)
    }
    
    func update(_ posting: Posting, with data: PostingResponseData) -> Posting {
        posting.headline = data.headline
        posting.content = data.content
        posting.comments = data.comments.map {
            self.save(with: $0, for: posting)
        }
        return posting
    }
    
    func create(with data: PostingResponseData) -> Posting {
        let creator = save(with: data.creator)
        let posting = Posting(with: data, by: creator, in: container.viewContext)
        
        posting.comments = data.comments.map {
            .init(with: $0, for: posting, by: save(with: $0.creator), in: container.viewContext)
        }
        
        do {
            try container.viewContext.save()
            print("saved new posting: \(posting.headline)")
        } catch {
            print(error)
            print("failed on posting: \(posting.headline)")
        }
        
        return posting
    }
    
    func delete(_ posting: Posting) {
        do {
            container.viewContext.delete(posting as NSManagedObject)
            try container.viewContext.save()
        } catch {
            print("deleting posting failed")
            print(error)
        }
    }
}

