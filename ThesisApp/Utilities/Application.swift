//
//  Application.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.08.22.
//

import Foundation

struct Application {
    
    static var token: String? {
        get { UserDefaults.standard.string(forKey: "token") }
        set { UserDefaults.standard.set(newValue, forKey: "token") }
    }

}
