//
//  LoginForm.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI
import WrappingHStack

struct LoginForm: View {
    
    @StateObject var model = LoginFormModel()
    var switchMode: () -> Void
    
    var body: some View {
        ZStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .offset(y: -120)
                .padding(.bottom, -150)
        }
        
        VStack(spacing: spacingMedium) {
            Text("Anmelden")
                .modifier(FontTitle())
            
            WrappingHStack() {
                Text("Bitte melde dich an um fortzufahren.")
                    .font(.custom(fontNormal, size: fontSizeHeadline3))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 2)
                Text("Noch kein Konto?")
                    .font(.custom(fontNormal, size: fontSizeHeadline3))
                ButtonText("Jetzt registrieren") {
                    switchMode()
                }
            }
    
            Spacer()
            
            VStack(spacing: spacingLarge) {
                ForEach(model.fields) { field in
                    InputField(field)
                }
            }
            
            Spacer()
            
            ButtonIcon(
                "Anmelden",
                icon: "arrow.forward",
                disabled: model.errors,
                action: model.submit
            )
        }
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            LoginForm(switchMode: {})
        }
    }
}
