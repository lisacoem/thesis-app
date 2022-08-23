//
//  AuthorizationView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

extension AuthorizationView {
    
    enum ViewState: CaseIterable {
        case login, registration
    }
    
    class ViewModel: ObservableObject {
        
        @Published var state: ViewState
        
        let session: Session
        let authorizationService: AuthorizationService
        let persistenceController: PersistenceController
        
        init(
            session: Session,
            authorizationService: AuthorizationService,
            persistenceController: PersistenceController
        ) {
            self.session = session
            self.authorizationService = authorizationService
            self.persistenceController = persistenceController
            self.state = .login
        }
        
        func navigateToLogin() {
            state = .login
        }
        
        func navigateToRegistration() {
            state = .registration
        }
    }
}

struct AuthorizationView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(
        session: Session,
        authorizationService: AuthorizationService,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                session: session,
                authorizationService: authorizationService,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        switch viewModel.state {
        case .login:
            LoginView(
                session: viewModel.session,
                authorizationService: viewModel.authorizationService,
                persistenceController: viewModel.persistenceController,
                navigateToRegistration: viewModel.navigateToRegistration
            )
        case .registration:
            RegistrationView(
                session: viewModel.session,
                authorizationService: viewModel.authorizationService,
                persistenceController: viewModel.persistenceController,
                navigateToLogin: viewModel.navigateToLogin
            )
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(
            session: Session(),
            authorizationService: AuthorizationMockService(),
            persistenceController: .preview
        )
    }
}
