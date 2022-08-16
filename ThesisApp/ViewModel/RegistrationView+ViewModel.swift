//
//  RegistrationView+ViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

extension RegistrationView {
    
    class ViewModel: FormModel {
        
        let navigateToLogin: () -> Void
        
        private let session: Session
        private let authorizationService: AuthorizationService
        private let persistenceController: PersistenceController
        
        @Published var mail: FieldModel
        @Published var firstName: FieldModel
        @Published var lastName: FieldModel
        @Published var password: FieldModel
        
        init(
            session: Session,
            authorizationService: AuthorizationService,
            persistenceController: PersistenceController,
            navigateToLogin: @escaping () -> Void
        ) {
            self.session = session
            self.authorizationService = authorizationService
            self.persistenceController = persistenceController
            self.navigateToLogin = navigateToLogin
            
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
        
        override var fields: [FieldModel] {
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
                            print("finished")
                        case .failure(_):
                            self.errorMessage = "Es ist ein Fehler aufgetreten"
                        }
                    },
                    receiveValue: { userData in
                        self.errorMessage = nil
                        self.session.login(
                            self.persistenceController.saveUser(with: userData),
                            token: userData.token
                        )
                })
        }
    }
}
