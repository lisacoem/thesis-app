//
//  Position.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.09.22.
//

import Foundation

public class Position: NSObject {
    var row: Int32
    var column: Int32
    
    init(row: Int32, column: Int32) {
        self.row = row
        self.column = column
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        row == (object as? Position)?.row && column == (object as? Position)?.column
    }
}
