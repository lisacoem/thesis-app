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
        set { creationDate_ = newValue.formatted ?? newValue }
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
        with data: PostingResponseData,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = data.id
        self.headline = data.headline
        self.content = data.content
        self.userName = data.userName
        self.userId = data.userId
        self.creationDate = data.creationDate
        self.comments = data.comments.map {
            Comment(with: $0, for: self, in: context)
        }
        self.keywords = data.keywords.compactMap { Keyword(rawValue: $0) }
    }
}

extension PersistenceController {

    func savePosting(with data: PostingResponseData) {
        let request = Posting.fetchRequest(NSPredicate(format: "id == %i", data.id))
        
        if (try? container.viewContext.fetch(request).first) != nil {
            // MARK: update comments
            return
        }
        
        let posting = Posting(with: data, in: container.viewContext)
        print("saved new posting: (\(posting.id)) \(posting.headline) from \(posting.userName)")
        try? container.viewContext.save()
    }
}

