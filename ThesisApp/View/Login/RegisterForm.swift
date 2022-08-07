//
//  RegisterForm.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct RegisterForm: View {
    
    @StateObject var model = RegisterFormModel()
    var switchMode: () -> Void
    
    var body: some View {
        VStack(spacing: spacingMedium) {
            
            Text("Registrieren")
                .modifier(FontTitle())
                .padding(.bottom, spacingExtraLarge)
            
            VStack(spacing: spacingLarge) {
                InputField(model.mail)
                InputField(model.firstName)
                InputField(model.lastName)
                InputField(model.password)
            }
            
            Spacer()
            
            
            ButtonIcon("Konto erstellen", icon: "arrow.forward", action: model.submit)
        }
        
        
    }
}

struct RegisterForm_Previews: PreviewProvider {
    static var previews: some View {
        RegisterForm(switchMode: {})
    }
}
