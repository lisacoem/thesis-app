//
//  Double+ToString.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import Foundation

extension Double {
    
    func toString() -> String {
        let integer: Int = Int(self)

        if (self - Double(integer)) > 0 {
            return String(format: "%.2F", self)
        }
        return "\(integer)"
    }
}
