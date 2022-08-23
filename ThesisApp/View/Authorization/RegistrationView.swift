//
//  RegistrationView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct RegistrationView: View {

    @StateObject var viewModel: ViewModel
    @FocusState var focusField: FieldModel?
    
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
        Container {
            VStack(spacing: Spacing.medium) {
                Button(action: viewModel.navigateToLogin) {
                    Image(systemName: "arrow.backward")
                        .font(.custom(Font.bold, size: IconSize.large))
                        .foregroundColor(.customBlack)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, Spacing.medium)
                        .id("top")
                }
                
                Text("Registrieren")
                    .modifier(FontTitle())
                    .padding(.bottom, Spacing.large)
            }
            
            VStack(spacing: Spacing.large) {
                ForEach(viewModel.fields) { field in
                    InputField(field, focusField: _focusField)
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: { focusField = viewModel.previousField(focusField) }) {
                    Image(systemName: "chevron.up")
                }
                .disabled(!viewModel.hasPreviousField(focusField))
                
                Button(action: { focusField = viewModel.nextField(focusField) }) {
                    Image(systemName: "chevron.down")
                }
                .disabled(!viewModel.hasNextField(focusField))
                
                Spacer()
                Button(action: { focusField =  nil }) {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct RegisterForm_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(
            session: Session(),
            authorizationService: AuthorizationMockService(),
            persistenceController: .preview,
            navigateToLogin: {}
        )
    }
}
