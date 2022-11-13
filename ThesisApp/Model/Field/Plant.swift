//
//  Plant.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation
import CoreData

@objc(Plant)
public class Plant: NSManagedObject {
    
    fileprivate(set) var seedingDate: Date? {
        get { seedingDate_ }
        set { seedingDate_ = newValue?.formatted ?? newValue }
    }
    
    fileprivate(set) var growthPeriod: TimeInterval {
        get { growthPeriod_ }
        set { growthPeriod_ = newValue.rounded(digits: 14) }
    }
    
    fileprivate(set) var field: Field {
        get { field_! }
        set { field_ = newValue }
    }
    
    fileprivate(set) var user: User {
        get { user_! }
        set { user_ = newValue }
    }
    
    fileprivate(set) var system: LindenmayerSystem {
        get { system_! }
        set { system_ = newValue }
    }
    
    fileprivate(set) var position: Position {
        get { .init(row: fieldRow, column: fieldColumn) }
        set {
            fieldRow = newValue.row
            fieldColumn = newValue.column
        }
    }
    
    var name: String {
        system.name
    }
}

extension Plant {
    
    var isSeeded: Bool {
        self.seedingDate != nil
    }
    
    var growingTime: TimeInterval {
        guard let seedingDate = self.seedingDate else {
            return 0
        }
        return Date.now.timeIntervalSince(seedingDate)
    }
    
    var progress: Double {
        if growingTime > growthPeriod {
            return 1
        }
        return growingTime / growthPeriod
    }
}

extension Plant: Comparable {
    
    public static func < (lhs: Plant, rhs: Plant) -> Bool {
        lhs.id < rhs.id
    }
}

extension Plant {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Plant> {
        let request = NSFetchRequest<Plant>(entityName: "Plant")
        request.sortDescriptors = [NSSortDescriptor(
            key: "seedingDate_",
            ascending: false
        )]
        request.predicate = predicate
        return request
    }
}

extension Plant {
    
    convenience init(
        with data: PlantData,
        for field: Field,
        by user: User,
        system: LindenmayerSystem,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.id = data.id
        self.seedingDate = data.seedingDate
        self.growthPeriod = data.growthPeriod
        self.position = data.position
        self.field = field
        self.user = user
        self.system = system
    }
}

extension PersistenceController {

    func createOrUpdate(with data: PlantData, for field: Field) -> Plant {
        let request = Plant.fetchRequest(NSPredicate(format: "id == %i", data.id))
        if let plant = try? container.viewContext.fetch(request).first {
            return update(plant, with: data)
        }
        return create(with: data, for: field)
    }
    
    func update(_ plant: Plant, with data: PlantData) -> Plant {
        plant.seedingDate = data.seedingDate
        plant.growthPeriod = data.growthPeriod
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
    
        return plant
    }
    
    func create(with data: PlantData, for field: Field) -> Plant {
        let plant = Plant(
            with: data,
            for: field,
            by: createOrUpdate(with: data.user),
            system: createOrUpdate(with: data.system),
            in: container.viewContext
        )
        
        do {
            try container.viewContext.save()
            print("saved new plant: \(plant.system.name) of \(plant.user.friendlyName)")
        } catch {
            print(error)
            print("failed on plant: \(plant.system.name) of \(plant.user.friendlyName)")
        }
        
        return plant
    }
}
