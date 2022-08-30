//
//  LoginView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: ViewModel
    @FocusState var focusField: FieldModel?
    
    init(authorizationService: AuthorizationService) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                authorizationService: authorizationService
            )
        )
    }
    
    var body: some View {
        Container {
            header
            intro
            
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
                "Anmelden",
                icon: "arrow.forward",
                disabled: viewModel.errors,
                action: viewModel.login
            )
        }
        .toolbar {
            FormToolbar(viewModel, focused: _focusField)
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Image("Header")
                .resizable()
                .scaledToFill()

            Text("Anmelden")
                .modifier(FontTitle())
        }
    }
    
    var intro: some View {
        VStack(alignment: .leading, spacing: Spacing.ultraSmall) {
            Text("Bitte melde dich an um fortzufahren.")
                .modifier(FontH4())
            
            HStack(spacing: Spacing.ultraSmall) {
                Text("Noch kein Konto?")
                    .modifier(FontH4())
    
                NavigationLink(destination: destination) {
                    Text("Jetzt registrieren")
                        .foregroundColor(.customOrange)
                        .modifier(FontH3())
                }
            }
        }
    }
    
    var destination: some View {
        RegistrationView(
            authorizationService: viewModel.authorizationService
        )
        .navigationLink()
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(
                authorizationService: AuthorizationMockService()
            )
        }
    }
}
