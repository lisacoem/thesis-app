//
//  UIColor+Random.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 21.09.22.
//

import SwiftUI

extension UIColor {

    static func random() -> UIColor {
        UIColor(
            red: .random(in: 0.0..<0.5) + 0.5,
            green: .random(in: 0.0..<0.5) + 0.5,
            blue: .random(in: 0.0..<0.5) + 0.5,
            alpha: 1
        )
    }
}
