//
//  Daytime.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import SwiftUI

enum Daytime: String, CaseIterable {
    case twilight = "TWILIGHT",
         midday = "MIDDAY",
         night = "NIGHT"
    
    var colors: [Color] {
        switch self {
        case .twilight:
            return [
                Color("TwilightStart"),
                Color("TwilightEnd")
            ]
        case .midday:
            return [
                Color("MiddayStart"),
                Color("MiddayEnd")
            ]
        case .night:
            return [
                Color("NightStart"),
                Color("NightEnd")
            ]
        }
    }
}
