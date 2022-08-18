//
//  LoginView+ViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

extension LoginView {
    
    class ViewModel: FormModel {
        
        let navigateToRegistration: () -> Void
        
        private let session: Session
        private let authorizationService: AuthorizationService
        private let persistenceController: PersistenceController
        
        @Published var mail: FieldModel
        @Published var password: FieldModel
        
        init(
            session: Session,
            authorizationService: AuthorizationService,
            persistenceController: PersistenceController,
            navigateToRegistration: @escaping () -> Void
        ) {
            self.session = session
            self.authorizationService = authorizationService
            self.persistenceController = persistenceController
            self.navigateToRegistration = navigateToRegistration
            
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
                    }
                ).store(in: &anyCancellable)
        }
    }
}
