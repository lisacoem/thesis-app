//
//  AppUserData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation

struct AppUserData: Decodable {
    
    private(set) var id: Int64
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var role: Role
    private(set) var token: String?
    private(set) var points: Double
    private(set) var team: TeamData?
    
    init(
        id: Int64,
        firstName: String,
        lastName: String,
        role: Role,
        token: String? = nil,
        points: Double,
        team: TeamData? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.token = token
        self.points = points
        self.team = team
    }
}
