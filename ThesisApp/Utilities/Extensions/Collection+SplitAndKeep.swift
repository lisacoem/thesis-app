//
//  Collection+SplitAndKeep.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 24.09.22.
//

import Foundation

extension Collection {
    
    func splitAndKeep(
        omittingEmptySubsequences: Bool = true,
        whereSeparator isSeparator: (Element) throws -> Bool
    ) rethrows -> [SubSequence] {
        if isEmpty {
            return []
        }

        var subsequences: [SubSequence] = []
        var start = startIndex
        
        func appendSubsequence(upTo: Index) {
            if !omittingEmptySubsequences || upTo != start {
                subsequences.append(self[start..<upTo])
            }
        }
        
        while var idx = try self[start...].indices
            .first(where: { try $0 != start && isSeparator(self[$0]) }) {
            
            appendSubsequence(upTo: idx)
            start = idx
            formIndex(after: &idx)
            appendSubsequence(upTo: idx)
            start = idx
        }

        appendSubsequence(upTo: endIndex)

        return subsequences
    }
}
