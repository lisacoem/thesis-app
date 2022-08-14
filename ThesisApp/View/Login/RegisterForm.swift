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
        VStack(spacing: Spacing.medium) {
            
            Image(systemName: "arrow.backward")
                .font(.custom(Font.bold, size: IconSize.large))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Spacing.medium)
                .onTapGesture {
                    switchMode()
                }
            
            Text("Registrieren")
                .modifier(FontTitle())
                .padding(.bottom, Spacing.large)
            
            VStack(spacing: Spacing.large) {
                ForEach(model.fields) { field in
                    InputField(field)
                }
            }
            
            if let errorMessage = model.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .modifier(FontText())
            }
            
            Spacer()
            
            ButtonIcon(
                "Konto erstellen",
                icon: "arrow.forward",
                disabled: model.errors,
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
