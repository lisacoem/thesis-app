//
//  Seed.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import CoreData

@objc(Seed)
public class Seed: NSManagedObject {
    
    fileprivate(set) var name: String {
        get { name_! }
        set { name_ = newValue }
    }
    
    fileprivate(set) var seasons: [Season] {
        get { seasons_?.map({ Season(rawValue: $0) }).compactMap { $0 } ?? [] }
        set { seasons_ = newValue.map { $0.rawValue } }
    }
    
    convenience init(
        id: Int64,
        name: String,
        price: Int16,
        seasons: [Season],
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.price = price
        self.seasons = seasons
    }
}
