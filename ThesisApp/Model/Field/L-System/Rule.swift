//
//  Rule.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 21.09.22.
//

import CoreData

@objc(Rule)
public class Rule: NSManagedObject {

    var replaceFrom: String {
        get { replaceFrom_! }
        set { replaceFrom_ = newValue }
    }

    var replaceTo: String {
        get { replaceTo_! }
        set { replaceTo_ = newValue }
    }

    convenience init(from data: RuleData, for system: LSystem, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.replaceFrom = data.replaceFrom
        self.replaceTo = data.replaceTo
        self.system = system
    }
}

extension PersistenceController {
    
    func save(with data: RuleData, for system: LSystem) -> Rule {
        let rule = Rule(from: data, for: system, in: container.viewContext)
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return rule
    }
}
