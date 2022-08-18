//
//  LoginView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(
        session: Session,
        authorizationService: AuthorizationService,
        persistenceController: PersistenceController,
        navigateToRegistration: @escaping () -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                session: session,
                authorizationService: authorizationService,
                persistenceController: persistenceController,
                navigateToRegistration: navigateToRegistration
            )
        )
    }
    
    var body: some View {
        ZStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .offset(y: -120)
                .padding(.bottom, -150)
        }
        
        VStack(spacing: Spacing.medium) {
            Text("Anmelden")
                .modifier(FontTitle())
            
            VStack(spacing: 0) {
                Text("Bitte melde dich an um fortzufahren.")
                    .modifier(FontH4())
                    .padding(.bottom, 2)
                
                HStack(spacing: 0) {
                    Text("Noch kein Konto?")
                        .font(.custom(Font.normal, size: FontSize.h3))
                    
                    ButtonText("Jetzt registrieren") {
                        viewModel.navigateToRegistration()
                    }
                }
            }
    
            Spacer()
            
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
                "Anmelden",
                icon: "arrow.forward",
                disabled: viewModel.errors,
                action: viewModel.login
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            LoginView(
                session: Session(),
                authorizationService: AuthorizationWebService(),
                persistenceController: .preview,
                navigateToRegistration: {}
            )
        }
    }
}
