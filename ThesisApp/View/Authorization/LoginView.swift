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
        Container {
            header
            intro
            
            inputFields            
            
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
        VStack(spacing: Spacing.large) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding(.top, -100)
                .padding(.bottom, -20)

            Text("Anmelden")
                .modifier(FontTitle())
        }
    }
    
    var intro: some View {
        VStack(spacing: 0) {
            Text("Bitte melde dich an um fortzufahren.")
                .modifier(FontH4())
                .padding(.bottom, 5)
            
            HStack(spacing: 0) {
                Text("Noch kein Konto?")
                    .font(.custom(Font.normal, size: FontSize.h3))
                    .padding(.trailing, 5)
                
                registrationLink
            }
        }
    }
    
    var registrationLink: some View {
        NavigationLink(destination: {
            RegistrationView(
                session: viewModel.session,
                authorizationService: viewModel.authorizationService,
                persistenceController: viewModel.persistenceController
            )
            .navigationLink()
        }) {
            Text("Jetzt registrieren")
                .font(.custom(Font.bold, size: FontSize.h3))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var inputFields: some View {
        VStack(spacing: Spacing.large) {
            ForEach(viewModel.fields) { field in
                InputField(field, focusField: _focusField)
            }
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.customRed)
                    .modifier(FontText())
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(
                session: Session(),
                authorizationService: AuthorizationMockService(),
                persistenceController: .preview
            )
        }
    }
}
