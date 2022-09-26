//
//  Movement.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData

@objc(Movement)
public class Movement: NSManagedObject {
    
    fileprivate(set) var value: String {
        get { value_! }
        set { value_ = newValue }
    }
    
    fileprivate(set) var name: String {
        get { name_! }
        set { name_ = newValue }
    }
    
    fileprivate(set) var symbol: String {
        get { symbol_! }
        set { symbol_ = newValue }
    }
    
    func isValid(speed: Double) -> Bool {
        speed >= minSpeed && speed <= maxSpeed
    }
}

extension Movement {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Movement> {
        let request = NSFetchRequest<Movement>(entityName: "Movement")
        request.sortDescriptors = [NSSortDescriptor(key: "value_", ascending: true)]
        request.predicate = predicate
        return request
    }
}

extension Movement {
    
    convenience init(with data: MovementData, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.value = data.value
        self.name = data.name
        self.symbol = data.symbol
        self.minSpeed = data.minSpeed
        self.maxSpeed = data.maxSpeed
    }
}

extension PersistenceController {
    
    func createOrUpdate(with data: MovementData) -> Movement {
        let request = Movement.fetchRequest(
            NSPredicate(format: "value_ = %@", data.value)
        )
        if let movement = try? container.viewContext.fetch(request).first {
            return update(movement, with: data)
        }
        return create(with: data)
    }
    
    func update(_ movement: Movement, with data: MovementData) -> Movement {
        movement.name = data.name
        movement.symbol = data.symbol
        movement.minSpeed = data.minSpeed
        movement.maxSpeed = data.maxSpeed
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        return movement
    }
    
    func create(with data: MovementData) -> Movement {
        let movement = Movement(with: data, in: container.viewContext)
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return movement
    }

}
