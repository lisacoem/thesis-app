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
        self.rows = data.rows
        self.columns = data.columns
        self.street = data.street
    }
}

extension Field {
    
    func plant(with position: Position) -> Plant? {
        return plants.filter({ $0.position == position }).first
    }
    
    func plant(row: Int32, column: Int32) -> Plant? {
        plants.filter({ $0.fieldRow == row && $0.fieldColumn == column }).first
    }
}

extension PersistenceController {
    
    func createOrUpdate(with data: FieldData) -> Field {
        let request = Field.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let field = try? container.viewContext.fetch(request).first {
            return update(field, with: data)
        }
        return create(with: data)
    }
    
    func create(with data: FieldData) -> Field {
        let field = Field(with: data, in: container.viewContext)
        field.plants = data.plants.map { createOrUpdate(with: $0, for: field) }
        field.seeds = data.seeds.map { createOrUpdate(with: $0, for: field) }
        
        do {
            try container.viewContext.save()
            print("saved new field: \(field.name)")
        } catch {
            print(error)
            print("failed on field: \(field.name)")
        }
        
        return field
    }
    
    func update(_ field: Field, with data: FieldData) -> Field {
        field.name = data.name
        field.size = data.size
        field.rows = data.rows
        field.columns = data.columns
        field.plants = data.plants.map { createOrUpdate(with: $0, for: field) }
        field.seeds = data.seeds.map { createOrUpdate(with: $0, for: field) }
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return field
    }
}

