//
//  Rule.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 21.09.22.
//

import CoreData

@objc(LindenmayerRule)
public class LindenmayerRule: NSManagedObject {

    var replaceFrom: String {
        get { replaceFrom_! }
        set { replaceFrom_ = newValue }
    }

    var replaceTo: String {
        get { replaceTo_! }
        set { replaceTo_ = newValue }
    }
}

extension LindenmayerRule {
    
    convenience init(
        from data: LindenmayerRuleData,
        for system: LindenmayerSystem,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.replaceFrom = data.replaceFrom
        self.replaceTo = data.replaceTo
        self.system = system
    }
}

extension PersistenceController {
    
    func create(
        with data: LindenmayerRuleData,
        for system: LindenmayerSystem
    ) -> LindenmayerRule {
        let rule = LindenmayerRule(
            from: data,
            for: system,
            in: container.viewContext
        )
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return rule
    }
}
