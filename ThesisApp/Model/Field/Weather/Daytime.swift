//
//  Daytime.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import SwiftUI

enum Daytime: String, CaseIterable, Decodable {
    case dawn = "DAWN",
         midday = "MIDDAY",
         dusk = "DUSK",
         night = "NIGHT"
}

extension Daytime {

    var colors: [Color] {
        switch (self) {
        case .dawn:
            return [
                Color("DawnStart"),
                Color("DawnEnd")
            ]
        case .midday:
            return [
                Color("MiddayStart"),
                Color("MiddayEnd")
            ]
        case .dusk:
            return [
                Color("DuskStart"),
                Color("DuskEnd")
            ]
        case .night:
            return [
                Color("NightStart"),
                Color("NightEnd")
            ]
        }
    }
}
