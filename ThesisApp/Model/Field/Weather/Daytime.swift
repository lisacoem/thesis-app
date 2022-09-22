//
//  Daytime.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import SwiftUI

enum Daytime: String, CaseIterable, Decodable {
    case twilight = "TWILIGHT",
         midday = "MIDDAY",
         night = "NIGHT"

}
