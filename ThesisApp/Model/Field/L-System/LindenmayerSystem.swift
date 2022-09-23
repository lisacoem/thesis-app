//
//  LindenmayerSystem.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 20.09.22.
//

import Foundation
import CoreData

@objc(LindenmayerSystem)
public class LindenmayerSystem: NSManagedObject {

    fileprivate(set) var name: String {
        get { name_! }
        set { name_ = newValue }
    }

    fileprivate(set) var axiom: String {
        get { axiom_! }
        set { axiom_ = newValue }
    }

    fileprivate(set) var rules: [LindenmayerRule] {
        get { (rules_ as? Set<LindenmayerRule>)?.shuffled() ?? [] }
        set { rules_ = Set(newValue) as NSSet }
    }
}

extension LindenmayerSystem {

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

    private func getRule(for character: Character) -> LindenmayerRule? {
        rules
            .filter({ $0.replaceFrom == String(character) })
            .first
    }

}

extension LindenmayerSystem {
    
    convenience init(with data: LindenmayerSystemData, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = data.name
        self.iterations = data.iterations
        self.length = data.length
        self.radius = data.radius
        self.axiom = data.axiom
        self.angle = data.angle
    }
}

extension LindenmayerSystem {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<LindenmayerSystem> {
        let request = NSFetchRequest<LindenmayerSystem>(entityName: "LindenmayerSystem")
        request.sortDescriptors = [NSSortDescriptor(
            key: "name_",
            ascending: true
        )]
        request.predicate = predicate
        return request
    }
}

extension PersistenceController {
    
    func save(with data: LindenmayerSystemData) -> LindenmayerSystem {
        let request = LindenmayerSystem.fetchRequest(NSPredicate(format: "name_ == %@", data.name))
        if let system = try? container.viewContext.fetch(request).first {
            return update(system, with: data)
        }

        let system = LindenmayerSystem(with: data, in: container.viewContext)
        system.rules = data.rules.map {
            save(with: $0, for: system)
        }
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return system
    }
    
    func update(_ system: LindenmayerSystem,with data: LindenmayerSystemData) -> LindenmayerSystem {
        system.iterations = data.iterations
        system.angle = data.angle
        system.length = data.length
        system.radius = data.radius
        system.axiom = data.axiom
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        return system
    }
}
