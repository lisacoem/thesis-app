//
//  Position.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.09.22.
//

import Foundation

public class Position: Codable, Equatable {
        
    var row: Int32
    var column: Int32
    
    init(row: Int32, column: Int32) {
        self.row = row
        self.column = column
    }
    
    public static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.row == rhs.row &&
        lhs.column == rhs.column
    }
}
