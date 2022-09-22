//
//  LSystem.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 20.09.22.
//

import Foundation
import CoreData

@objc(LSystem)
public class LSystem: NSManagedObject {
    
    fileprivate(set) var name: String {
        get { name_! }
        set { name_ = newValue }
    }

    fileprivate(set) var angle: Angle {
        get { Angle(angle_) }
        set { angle_ = newValue.degrees }
    }

    fileprivate(set) var axiom: String {
        get { axiom_! }
        set { axiom_ = newValue }
    }

    fileprivate(set) var rules: [Rule] {
        get { (rules_ as? Set<Rule>)?.shuffled() ?? [] }
        set { rules_ = Set(newValue) as NSSet }
    }
}

extension LSystem {

    func sentence(for iterations: Int) -> String {
        var sentence = axiom
        for _ in 0...iterations {
            sentence = applyRules(to: sentence)
        }
        return sentence
    }

    private func applyRules(to sentence: String) -> String {
        var newSentence = ""
        for character in sentence {
            if let rule = getRule(for: character) {
                newSentence += rule.replaceTo
            } else {
                newSentence += String(character)
            }
        }
        return newSentence
    }

    private func getRule(for character: Character) -> Rule? {
        rules
            .filter({ $0.replaceFrom == String(character) })
            .first
    }
}

extension LSystem {
    
    convenience init(with data: LSystemData, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = data.name
        self.iterations = data.iterations
        self.length = data.length
        self.radius = data.radius
        self.axiom = data.axiom
        self.angle = Angle(data.angle)
    }
}

extension LSystem {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<LSystem> {
        let request = NSFetchRequest<LSystem>(entityName: "LSystem")
        request.sortDescriptors = [NSSortDescriptor(
            key: "name_",
            ascending: true
        )]
        request.predicate = predicate
        return request
    }
}

extension PersistenceController {
    
    func save(with data: LSystemData) -> LSystem {
        let request = LSystem.fetchRequest(NSPredicate(format: "name_ == %@", data.name))
        if let lSystem = try? container.viewContext.fetch(request).first {
            return update(lSystem, with: data)
        }

        let lSystem = LSystem(with: data, in: container.viewContext)
        lSystem.rules = data.rules.map {
            save(with: $0, for: lSystem)
        }
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return lSystem
    }
    
    func update(_ lSystem: LSystem, with data: LSystemData) -> LSystem {
        lSystem.iterations = data.iterations
        lSystem.angle = Angle(data.angle)
        lSystem.length = data.length
        lSystem.radius = data.radius
        lSystem.axiom = data.axiom
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        return lSystem
    }
}
