//
//  LoginUserModel.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

class LoginModel: ObservableObject {

    @Published var mail: String = ""
    @Published var password: String = ""
    
    static func isValidMail(_ email: String) -> Bool {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailFormat = name + "@" + domain + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        let passwordFormat = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[$@$#!%*?&]).{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: password)
    }
}
