//
//  Field.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation
import CoreData

@objc(Field)
public class Field: NSManagedObject {

    fileprivate(set) var name: String {
        get { name_! }
        set { name_ = newValue }
    }
    
    fileprivate(set) var street: String {
        get { street_! }
        set { street_ = newValue }
    }
    
    fileprivate(set) var size: Double {
        get { size_ }
        set { size_ = newValue.rounded(digits: 2) }
    }
    
    fileprivate(set) var plants: [Plant] {
        get { (plants_ as? Set ?? []).sorted() }
        set { plants_ = Set(newValue) as NSSet }
    }
    
    fileprivate(set) var seeds: [Seed] {
        get { (seeds_ as? Set ?? []).sorted() }
        set { seeds_ = Set(newValue) as NSSet }
    }
}

extension Field {
    
    static func == (lhs: Field, rhs: Field) -> Bool {
        lhs.id == rhs.id
    }
}

extension Field {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Field> {
        let request = NSFetchRequest<Field>(entityName: "Field")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        return request
    }
}

extension Field {
    
    convenience init(
        with data: FieldData,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = data.id
        self.name = data.name
        self.size = data.size
        self.street = data.street
    }
}

extension PersistenceController {

    func saveField(with data: FieldData) {
        let request = Field.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let field = try? container.viewContext.fetch(request).first {
            print("found existing field: \(field.name)")
            field.name = data.name
            field.size = data.size
            field.plants = data.plants.map { getPlant(with: $0, for: field) }
            field.seeds = data.seeds.map { getSeed(with: $0, for: field) }
            try? container.viewContext.save()
            return
        }
        
        let field = Field(with: data, in: container.viewContext)
        field.plants = data.plants.map { getPlant(with: $0, for: field) }
        field.seeds = data.seeds.map { getSeed(with: $0, for: field) }
        
        do {
            try container.viewContext.save()
            print("saved new field: \(field.name)")
        } catch {
            print(error)
            print("failed on field: \(field.name)")
        }
    }
    
    func getField(with data: FieldData) -> Field {
        let request = Field.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let field = try? container.viewContext.fetch(request).first {
            print("found existing field: \(field.name)")
            field.name = data.name
            field.size = data.size
            field.plants = data.plants.map { getPlant(with: $0, for: field) }
            field.seeds = data.seeds.map { getSeed(with: $0, for: field) }
            try? container.viewContext.save()
            return field
        }
        
        let field = Field(with: data, in: container.viewContext)
        field.plants = data.plants.map { getPlant(with: $0, for: field) }
        field.seeds = data.seeds.map { getSeed(with: $0, for: field) }
        
        do {
            try container.viewContext.save()
            print("saved new field: \(field.name)")
        } catch {
            print(error)
            print("failed on field: \(field.name)")
        }
        
        return field
    }
}

