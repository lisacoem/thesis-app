//
//  Validator.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

enum Validator {
    
    static func name(_ name: String) -> Bool {
        let nameFormat = "[A-Za-zäöüÄÖÜß]([A-Za-zäöüÄÖÜß-]{0,30}[A-Za-zäöüÄÖÜß])?"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameFormat)
        return namePredicate.evaluate(with: name)
    }
    
    static func mail(_ mail: String) -> Bool {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let mailFormat = name + "@" + domain + "[A-Za-z]{2,8}"
        let mailPredicate = NSPredicate(format: "SELF MATCHES %@", mailFormat)
        return mailPredicate.evaluate(with: mail)
    }
    
    static func password(_ password: String) -> Bool {
        let passwordFormat = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[$@$#!%*?&]).{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: password)
    }
    
    
}
