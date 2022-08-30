//
//  LoginViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

extension LoginView {
    
    class ViewModel: FormModel {
        
        let session: Session
        let authorizationService: AuthorizationService
        let persistenceController: PersistenceController
        
        @Published var mail: FieldModel
        @Published var password: FieldModel
        
        init(
            session: Session,
            authorizationService: AuthorizationService,
            persistenceController: PersistenceController
        ) {
            self.session = session
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
        
        override var fields: [FieldModel] {
            return [mail, password]
        }
        
        private var data: LoginData {
            .init(mail: mail.value, password: password.value)
        }
        
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
                    receiveValue: { user in
                        self.session.login(user)
                    }
                )
                .store(in: &anyCancellable)
        }
    }
}
