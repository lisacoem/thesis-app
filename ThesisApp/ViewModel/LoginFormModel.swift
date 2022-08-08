//
//  LoginUserModel.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

class LoginFormModel: FormModel {
    
    @Published var mail = FieldModel(
        label: "E-Mail",
        validate: Validator.mail
    )
    @Published var password = FieldModel(
        label: "Password",
        secure: true,
        validate: Validator.password
    )
    
    @Published var errorMessage: String?
    
    var errors: Bool {
        mail.errors && password.errors
    }
    
    func submit() {
        let dto = UserLoginDto(mail: mail.value, password: password.value)
        do {
            try NetworkController.login(dto)
            errorMessage = nil
        } catch {
            errorMessage = "Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut"
            print(error)
        }
    }
    
    func reset() {
        mail.value = ""
        password.value = ""
        errorMessage = nil
    }
}
