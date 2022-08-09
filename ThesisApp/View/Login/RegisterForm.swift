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
            
            Image(systemName: "arrow.backward")
                .font(.custom(fontBold, size: iconSizeLarge))
                .foregroundColor(colorBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, spacingLarge)
                .onTapGesture {
                    switchMode()
                }
            
            Text("Registrieren")
                .modifier(FontTitle())
                .padding(.bottom, spacingExtraLarge)
            
            VStack(spacing: spacingLarge) {
                TextInput(model.mail)
                TextInput(model.firstName)
                TextInput(model.lastName)
                TextInput(model.password)
            }
            
            Spacer()
            
            ButtonIcon(
                "Konto erstellen",
                icon: "arrow.forward",
                action: model.submit
            )
        }
        
        
    }
}

struct RegisterForm_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            RegisterForm(switchMode: {})
        }
    }
}
