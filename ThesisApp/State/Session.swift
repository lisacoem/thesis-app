//
//  Session.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 16.08.22.
//

import Foundation

class Session: ObservableObject {
    
    @Published var user: User?
    
    var role: Role? { user?.role }
    
    var firstName: String? { user?.firstName }
    var lastName: String? { user?.lastName }
    var friendlyName: String? { user?.friendlyName }
    
    var isAuthorized: Bool { user != nil }

}

extension Session {
    
    func login(_ user: User?, token: String? = nil) {
        self.user = user
        
        if let token = token {
            SessionStorage.token = token
        }
        
        if let id = user?.id {
            SessionStorage.userId = Int(id)
        }
    }
}
