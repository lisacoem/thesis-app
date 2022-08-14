//
//  RegisterFormModel.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation
import Combine

class RegisterFormModel: FormModel {
    
    @Published var mail = FieldModel(
        label: "E-Mail",
        validate: Validator.mail
    )
    @Published var firstName = FieldModel(
        label: "Vorname",
        validate: Validator.name
    )
    @Published var lastName = FieldModel(
        label: "Nachname",
        validate: Validator.name
    )
    @Published var password = FieldModel(
        label: "Password",
        type: .Password,
        validate: Validator.password
    )
    
    override var fields: [FieldModel] {
        [mail, firstName, lastName, password]
    }
    
    func submit() {
        let dto = UserRegisterDto(
            mail: mail.value,
            firstName: firstName.value,
            lastName: lastName.value,
            password: password.value,
            role: .Participant
        )
        do {
            try NetworkController.register(dto)
            errorMessage = nil
        } catch {
            errorMessage = "Registrierung fehlgeschlagen. Bitte versuchen Sie es erneut"
            print(error)
        }
    }
}
