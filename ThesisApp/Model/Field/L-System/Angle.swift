//
//  Angle.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 21.09.22.
//

import Foundation

struct Angle {
    var degrees: Float
    var radians: Float

    init(_ degrees: Float) {
        self.degrees = degrees
        self.radians = degrees * .pi / 180
    }
}
