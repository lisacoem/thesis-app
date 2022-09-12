//
//  Double+Rounded.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation

extension Double {

    func rounded(digits: Int) -> Double {
        let powNum = pow(10.0, Double(digits))
        return (self * powNum).rounded() / powNum
    }
}
