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
    
    fileprivate(set) var field: Field {
        get { field_! }
        set { field_ = newValue }
    }
    
    convenience init(
        id: Int64,
        name: String,
        price: Int32,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.price = price
    }
}

extension Seed: Comparable {
    
    public static func < (lhs: Seed, rhs: Seed) -> Bool {
        if lhs.price == rhs.price {
            return lhs.name < rhs.name
        }
        return lhs.price < rhs.price
    }
}


extension Seed {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Seed> {
        let request = NSFetchRequest<Seed>(entityName: "Seed")
        request.sortDescriptors = [NSSortDescriptor(
            key: "name_",
            ascending: false
        )]
        request.predicate = predicate
        return request
    }
}

extension Seed {
    
    convenience init(
        with data: SeedData,
        for field: Field,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = data.id
        self.name = data.name
        self.price = data.price
        self.field = field
    }
}

extension PersistenceController {

    func getSeed(with data: SeedData, for field: Field) -> Seed {
        let request = Seed.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let seed = try? container.viewContext.fetch(request).first {
            print("found existing seed: \(seed.name) of \(seed.field.name)")
            seed.price = data.price
            try? container.viewContext.save()
            return seed
        }
        
        let seed = Seed(with: data, for: field, in: container.viewContext)
        
        do {
            try container.viewContext.save()
            print("saved new seed: \(seed.name) for \(seed.field.name)")
        } catch {
            print(error)
            print("failed on seed: \(seed.name) for \(seed.field.name)")
        }
        
        return seed
    }
}


