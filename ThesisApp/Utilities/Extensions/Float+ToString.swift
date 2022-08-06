//
//  Float+ToString.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import Foundation

extension Float {
    
    func toString() -> String {
        let integer: Int = Int(self)

        if (self - Float(integer)) > 0 {
            return String(format: "%.2F", self)
        }
        return "\(integer)"
    }
}
