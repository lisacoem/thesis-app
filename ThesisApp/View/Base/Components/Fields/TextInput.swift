//
//  TextInput.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct TextInput: View {
    
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
            .foregroundColor(valid ? colorBlack : colorRed)
            .font(.custom(fontNormal, size: fontSizeText))
            .placeholder(
                model.placeholder,
                when: model.value.isEmpty,
                color: colorLightBrown
            )
            .underline(color: valid ? colorLightBrown : colorRed)
            .onChange(of: model.value) { value in
                valid = model.validate(value)
            }
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: spacingLarge) {
            TextInput(.init(
                label: "E-Mail",
                placeholder: "example@mail.com",
                validate: Validator.mail
            ))
            TextInput(.init(
                label: "Nutzername",
                value: "Nutzername123",
                validate: Validator.name
            ))
            TextInput(.init(
                label: "Passwort",
                value: "1234",
                secure: true
            ))
       }.padding()
    }
}
