//
//  RegisterForm.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct RegistrationView: View {

    @StateObject var viewModel: ViewModel
    
    init(
        session: Session,
        authorizationService: AuthorizationService,
        persistenceController: PersistenceController,
        navigateToLogin: @escaping () -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                session: session,
                authorizationService: authorizationService,
                persistenceController: persistenceController,
                navigateToLogin: navigateToLogin
            )
        )
    }
    
    var body: some View {
        VStack(spacing: Spacing.medium) {
            
            Button(action: viewModel.navigateToLogin) {
                Image(systemName: "arrow.backward")
                .font(.custom(Font.bold, size: IconSize.large))
                .foregroundColor(.customBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Spacing.medium)
            }
            
            Text("Registrieren")
                .modifier(FontTitle())
                .padding(.bottom, Spacing.large)
            
            VStack(spacing: Spacing.large) {
                ForEach(viewModel.fields) { field in
                    InputField(field)
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.customRed)
                    .modifier(FontText())
            }
            
            Spacer()
            
            ButtonIcon(
                "Konto erstellen",
                icon: "arrow.forward",
                disabled: viewModel.errors,
                action: viewModel.signup
            )
        }
    }
}

struct RegisterForm_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            RegistrationView(
                session: Session(),
                authorizationService: AuthorizationMockService(),
                persistenceController: .preview,
                navigateToLogin: {}
            )
        }
    }
}
