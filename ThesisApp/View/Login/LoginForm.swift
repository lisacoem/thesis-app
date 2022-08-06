//
//  LoginForm.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct LoginForm: View {
    
    @StateObject var model = LoginModel()
    
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
            Text("Bitte melde dich an um fortzufahren.\nNoch kein Konto? Jetzt registrieren")
                .modifier(FontText())
            
            Spacer()
            
            VStack(spacing: spacingLarge) {
                InputField("E-Mail", text: $model.mail, validate: LoginModel.isValidMail)
                InputField("Passwort", text: $model.password, secure: true, validate: LoginModel.isValidPassword)
            }
            
            Spacer()
            
            ButtonIcon("Anmelden", icon: "arrow.forward", action: login)
        }
    }
    
    func login() {
        let data = UserLoginDto(mail: model.mail, password: model.password)
        do {
            try NetworkController.login(data)
        } catch {
            print(error)
        }
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        Page {
            LoginForm()
        }
    }
}
