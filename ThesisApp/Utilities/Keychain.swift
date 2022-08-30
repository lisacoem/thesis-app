//
//  SessionStorage.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.08.22.
//

import Foundation
import SwiftKeychainWrapper

struct Keychain {
    
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
}
