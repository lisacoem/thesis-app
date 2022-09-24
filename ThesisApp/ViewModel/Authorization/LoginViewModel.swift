//
//  LoginViewModel.swift
//  ThesisApp
//
//  ViewModel of LoginView
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

extension LoginView {
    
    class ViewModel: FormModel {
        
        let authorizationService: AuthorizationService
        let persistenceController: PersistenceController
        
        @Published private(set) var mail: InputFieldModel
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
            self.password = .init(
                label: "Password",
                type: .password,
                validate: Validator.password
            )
            super.init()
        }
        
        override var fields: [InputFieldModel] {
            return [mail, password]
        }
        
        private var data: LoginData {
            .init(mail: mail.value, password: password.value)
        }
        
        /// Login user with entered mail and password.
        /// Add error message if login attempt fails
        func login() {
            authorizationService.login(data)
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
        
        /// Reset previous user data, store points, userId and authorization status in UserDefaults and save authorization token in Keychain
        /// - Parameter response: API response data
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
