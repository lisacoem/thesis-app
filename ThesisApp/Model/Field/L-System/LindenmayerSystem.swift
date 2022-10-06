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
    
    fileprivate(set) var color: String {
        get { color_! }
        set { color_ = newValue }
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
    
    /// Apply rules to given sentence
    /// - Parameter sentence: sentence to replace characters from
    /// - Returns: new sentence with replaced characters
    private func applyRules(to sentence: String) -> String {
        var newSentence = ""
        let symbols = LindenmayerSymbol.allCases.map { $0.rawValue }
   
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
    
    func segments(for iterations: Int) -> [LindenmayerSegment] {
        segments(from: sentence(for: iterations))
    }
    
    private func segments(from string: String) -> [LindenmayerSegment] {
        let symbols = LindenmayerSymbol.allCases.map { $0.rawValue }
        return string
            .splitAndKeep(whereSeparator: symbols.contains)
            .compactMap { segment(from: $0) }
    }
  
    private func segment(from sequence: String.SubSequence) -> LindenmayerSegment? {
        guard let first = sequence.first,
              let symbol = LindenmayerSymbol(rawValue: first)
        else {
            return nil
        }
        
        let parameterDelimiters = Set<Character>("(,)")
        let parameters = sequence
            .split(whereSeparator: parameterDelimiters.contains)
            .compactMap { Float($0) }
        
        return LindenmayerSegment(
            symbol: symbol,
            parameters: parameters
        )
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
        self.color = data.color
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
    
    func createOrUpdate(with data: LindenmayerSystemData) -> LindenmayerSystem {
        let request = LindenmayerSystem.fetchRequest(NSPredicate(format: "name_ == %@", data.name))
        if let system = try? container.viewContext.fetch(request).first {
            return update(system, with: data)
        }

        let system = LindenmayerSystem(with: data, in: container.viewContext)
        system.rules = data.rules.map {
            create(with: $0, for: system)
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
