//
//  UserDefaults+Keys.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 30.08.22.
//

import Foundation
import SwiftUI

enum UserDefaultsKey: String, CaseIterable {
    case isLoggedIn,
         isTeamRequired,
         points,
         activityVersionToken,
         pinboardVersionToken
}

extension UserDefaults {
    
    func clear() {
        set(false, for: .isLoggedIn)
        set(true, for: .isTeamRequired)
        set(nil, for: .points)
        set(nil, for: .activityVersionToken)
        set(nil, for: .pinboardVersionToken)
    }
}

extension UserDefaults {
    
    func set(_ value: Any?, for key: UserDefaultsKey) {
        self.set(value, forKey: key.rawValue)
    }
    
    func bool(for key: UserDefaultsKey) -> Bool {
        self.bool(forKey: key.rawValue)
    }
    
    func data(for key: UserDefaultsKey) -> Data? {
        self.data(forKey: key.rawValue)
    }
    
    func string(for key: UserDefaultsKey) -> String? {
        self.string(forKey: key.rawValue)
    }
    
    func integer(for key: UserDefaultsKey) -> Int? {
        self.integer(forKey: key.rawValue)
    }
    
    func float(for key: UserDefaultsKey) -> Float? {
        self.float(forKey: key.rawValue)
    }
    
    func double(for key: UserDefaultsKey) -> Double? {
        self.double(forKey: key.rawValue)
    }
    
    func url(for key: UserDefaultsKey) -> URL? {
        self.url(forKey: key.rawValue)
    }
    
    func value(for key: UserDefaultsKey) -> Any? {
        self.value(forKey: key.rawValue)
    }
    
}

extension AppStorage {
    
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == Bool {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == Int {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == Double {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == URL {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == String {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == Data {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
}
