//
//  SessionStorage.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.08.22.
//

import Foundation
import SwiftKeychainWrapper

struct SessionStorage {
    
    static var token: String? {
        get { KeychainWrapper.standard.string(forKey: "token") }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: "token")
            } else {
                KeychainWrapper.standard.remove(forKey: "token")
            }
        }
    }
    
    static var userId: Int? {
        get { KeychainWrapper.standard.integer(forKey: "userId") }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: "userId")
            } else {
                KeychainWrapper.standard.remove(forKey: "userId")
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
    
    static func clear() {
        token = nil
        userId = nil
        activityVersionToken = nil
        pinboardVersionToken = nil
    }

}
