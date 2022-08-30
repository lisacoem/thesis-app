//
//  Session.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 16.08.22.
//

import Foundation

class Session: ObservableObject {
    
    @Published var userId: Int? {
        didSet {
            SessionStorage.userId = userId
        }
    }
    
    @Published var firstName: String? {
        didSet {
            SessionStorage.firstName = firstName
        }
    }
    
    @Published var lastName: String? {
        didSet {
            SessionStorage.lastName = lastName
        }
    }
    
    @Published var points: Double? {
        didSet {
            SessionStorage.points = points
        }
    }
    
    @Published var teamId: Int? {
        didSet {
            SessionStorage.teamId = teamId
        }
    }
    
    var isAuthorized: Bool { userId != nil }
    var isTeamRequired: Bool { isAuthorized && teamId == nil }

    private init(fromMemory: Bool = true) {
        if fromMemory {
            userId = SessionStorage.userId
            firstName = SessionStorage.firstName
            lastName = SessionStorage.lastName
            points = SessionStorage.points
            teamId = SessionStorage.teamId
        } else {
            SessionStorage.clear()
        }
    }
}

extension Session {
    
    static let shared = Session()
    static let preview = Session(fromMemory: false)

}

extension Session {
    
    func login(_ user: AppUserData) {
        self.userId = Int(user.id)
        
        if let team = user.team {
            self.teamId = Int(team.id)
        } else {
            self.teamId = nil
        }
        
        SessionStorage.authorizationToken = user.token
    }
}
