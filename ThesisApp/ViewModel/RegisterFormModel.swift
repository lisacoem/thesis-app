//
//  RegisterUserModel.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

class RegisterFormModel: FormModel {
    
    @Published var mail = FieldModel(label: "E-Mail", validate: Validators.mail)
    @Published var firstName = FieldModel(label: "Vorname", validate: Validators.name)
    @Published var lastName = FieldModel(label: "Nachname", validate: Validators.name)
    @Published var password = FieldModel(label: "Password", secure: true, validate: Validators.password)
    
    @Published var errorMessage: String?
    
    var errors: Bool {
        mail.errors && firstName.errors && lastName.errors && password.errors
    }
    
    func submit() {
        let dto = UserDto(
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
    
    func reset() {
        mail.value = ""
        firstName.value = ""
        lastName.value = ""
        password.value = ""
        errorMessage = nil
    }
}
