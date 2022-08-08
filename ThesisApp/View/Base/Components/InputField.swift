//
//  InputField.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct InputField: View {
    
    @ObservedObject var model: FieldModel
    @State var valid = true
    
    init(_ model: FieldModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(model.label)
                .font(.custom(fontBold, size: fontSizeText))
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                if model.secure {
                    SecureField("", text: $model.value)
                } else {
                    TextField("", text: $model.value)
                }
            }
            .onChange(of: model.value) { value in
                valid = model.validate(value)
            }
            .foregroundColor(valid ? colorBlack : colorRed)
            .font(.custom(fontNormal, size: fontSizeText))
            .placeholder(model.placeholder, when: model.value.isEmpty)
            .underline(color: valid ? colorBeige : colorRed)
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: spacingLarge) {
            InputField(.init(
                label: "E-Mail",
                placeholder: "example@mail.com",
                validate: Validators.mail
            ))
            InputField(.init(
                label: "Nutzername",
                value: "Nutzername123",
                validate: Validators.name
            ))
            InputField(.init(
                label: "Passwort",
                value: "1234",
                secure: true
            ))
       }.padding()
    }
}
