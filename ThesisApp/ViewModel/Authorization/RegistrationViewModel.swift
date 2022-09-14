//
//  RegistrationViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

extension RegistrationView {
    
    class ViewModel: FormModel {
        
        private let authorizationService: AuthorizationService
        private let persistenceController: PersistenceController
        
        @Published private(set) var mail: InputFieldModel
        @Published private(set) var firstName: InputFieldModel
        @Published private(set) var lastName: InputFieldModel
        @Published private(set) var password: InputFieldModel
        
        init(
            authorizationService: AuthorizationService,
            persistenceController: PersistenceController
        ) {
            self.authorizationService = authorizationService
            self.persistenceController = persistenceController
            
            self.mail = .init(
                label: "E-Mail",
                type: .email,
                validate: Validator.mail
            )
            self.firstName = .init(
                label: "Vorname",
                contentType: .givenName,
                validate: Validator.name
            )
            self.lastName = .init(
                label: "Nachname",
                contentType: .familyName,
                validate: Validator.name
            )
            self.password = .init(
                label: "Password",
                type: .password,
                validate: Validator.password
            )
            super.init()
        }
        
        override var fields: [InputFieldModel] {
            return [mail, firstName, lastName, password]
        }
        
        private var data: RegistrationData {
            .init(
                mail: mail.value,
                firstName: firstName.value,
                lastName: lastName.value,
                password: password.value
            )
        }
        
        func signup() {
            authorizationService.signup(data)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            self.errorMessage = nil
                        case .failure(_):
                            self.errorMessage = "Es ist ein Fehler aufgetreten"
                        }
                    },
                    receiveValue: { user in
                        self.persistenceController.resetUserData()
                        self.authorizationService.store(user)
                    }
                )
                .store(in: &anyCancellable)
        }
    }
}
