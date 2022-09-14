//
//  RegistrationView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct RegistrationView: View {

    @StateObject var viewModel: ViewModel
    @FocusState var focusField: InputFieldModel?
    
    init(
        authorizationService: AuthorizationService,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                authorizationService: authorizationService,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        Container {
            Spacer()
            
            Text("Registrieren")
                .modifier(FontTitle())
            
            ForEach(viewModel.fields) { field in
                InputField(field, focusField: _focusField)
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
            FormToolbar(viewModel, focused: _focusField)
        }
    }
}

struct RegisterForm_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(
            authorizationService: AuthorizationMockService(),
            persistenceController: .preview
        )
    }
}
