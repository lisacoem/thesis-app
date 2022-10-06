//
//  LindenmayerSegment.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 24.09.22.
//

import Foundation

struct LindenmayerSegment {
    var symbol: LindenmayerSymbol
    var parameters: [Float]
    
    var string: String {
        if parameters.isEmpty {
            return "\(symbol)"
        }
    
        var string = "\(symbol)("
        for parameter in parameters {
            if parameter == parameters.last {
                string += "\(parameter))"
            } else {
                string += "\(parameter),"
            }
        }
        return string
    }
}
