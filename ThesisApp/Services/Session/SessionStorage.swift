//
//  SessionStorage.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.08.22.
//

import Foundation
import SwiftKeychainWrapper

struct SessionStorage {
    
    static var userId: Int? {
        get { UserDefaults.standard.integer(forKey: "User.id") }
        set { UserDefaults.standard.set(newValue, forKey: "User.id") }
    }
    
    static var teamId: Int? {
        get { UserDefaults.standard.integer(forKey: "User.teamId") }
        set { UserDefaults.standard.set(newValue, forKey: "User.teamId") }
    }
    
    static var firstName: String? {
        get { UserDefaults.standard.string(forKey: "User.firstName") }
        set { UserDefaults.standard.set(newValue, forKey: "User.firstName") }
    }
    
    static var lastName: String? {
        get { UserDefaults.standard.string(forKey: "User.lastName") }
        set { UserDefaults.standard.set(newValue, forKey: "User.lastName") }
    }
    
    static var points: Double? {
        get { UserDefaults.standard.double(forKey: "User.points") }
        set { UserDefaults.standard.set(newValue, forKey: "User.points") }
    }

}

extension SessionStorage {
    
    static var authorizationToken: String? {
        get { KeychainWrapper.standard.string(forKey: "Authorization.token") }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: "Authorization.token")
            } else {
                KeychainWrapper.standard.remove(forKey: "Authorization.token")
            }
        }
    }
    
    static var pinboardVersionToken: String? {
        get { UserDefaults.standard.string(forKey: "Pinboard.versionToken") }
        set { UserDefaults.standard.set(newValue, forKey: "Pinboard.versionToken") }
    }
    
    static var activityVersionToken: String? {
        get { UserDefaults.standard.string(forKey: "Activities.versionToken") }
        set { UserDefaults.standard.set(newValue, forKey: "Activities.versionToken") }
    }
}

extension SessionStorage {
    
    static func clear() {
        userId = nil
        firstName = nil
        lastName = nil
        points = nil
        teamId = nil
        
        authorizationToken = nil
        activityVersionToken = nil
        pinboardVersionToken = nil
    }
}
