//
//  LoginFormModel.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation
import Combine

class LoginFormModel: FormModel {
    
    @Published var mail = FieldModel(
        label: "E-Mail",
        validate: Validator.mail
    )
    @Published var password = FieldModel(
        label: "Password",
        type: .Password,
        validate: Validator.password
    )
    
    override var fields: [FieldModel] {
        return [mail, password]
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
}
