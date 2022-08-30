//
//  Role.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation

enum Role: String, CaseIterable, Codable {
    case participant = "PARTICIPANT",
         contractor = "CONTRACTOR"
}
