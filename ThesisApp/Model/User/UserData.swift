//
//  UserData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation
import CoreData

struct UserData: Codable {
    private(set) var id: Int64
    private(set) var firstName: String
    private(set) var lastName: String
}
