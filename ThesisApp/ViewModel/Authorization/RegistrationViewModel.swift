//
//  RegistrationViewModel.swift
//  ThesisApp
//
//  ViewModel of RegistrationView
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
        
        /// signup user with entered personal data
        /// add errormessage if registration fails
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
                    receiveValue: resolve
                )
                .store(in: &cancellables)
        }
        
        /// reset previous user data, store points, userId and authorization status in user defaults and save authorization token in keychain
        /// - Parameter response: api response data
        func resolve(_ response: AppUserData) {
            self.persistenceController.resetUserData()
            
            UserDefaults.standard.set(true, for: .isLoggedIn)
            UserDefaults.standard.set(response.team == nil, for: .isTeamRequired)
            UserDefaults.standard.set(response.points, for: .points)
            UserDefaults.standard.set(response.id, for: .userId)

            Keychain.authorizationToken = response.token
        }
    }
}
