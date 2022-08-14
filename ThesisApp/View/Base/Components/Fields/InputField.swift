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
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(model.label)
                .font(.custom(fontBold, size: fontSizeText))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)

            Group {
                switch model.type {
                case .Text:
                    TextField("", text: $model.value)
                case .Password:
                    SecureField("", text: $model.value)
                case .TextArea:
                    TextEditor(text: $model.value)
                        .frame(minHeight: 0, maxHeight: 150)
                }
            }
            .padding([.top, .bottom], spacingSmall)
            .padding([.leading, .trailing], 5)
            .foregroundColor(valid ? colorBlack : colorRed)
            .background(colorLightBeige)
            .font(.custom(fontNormal, size: fontSizeText))
            .placeholder(
                model.placeholder,
                when: model.value.isEmpty,
                color: colorLightBrown
            )
            .onChange(of: model.value) { value in
                valid = model.validate(value)
            }
            
            Rectangle()
                .frame(height: 2.5)
                .foregroundColor(colorLightBrown)
                .opacity(0.7)
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            VStack(spacing: spacingLarge) {
                InputField(.init(
                    label: "E-Mail",
                    placeholder: "example@mail.com",
                    validate: Validator.mail
                ))
                InputField(.init(
                    label: "Nutzername",
                    value: "Nutzername123",
                    validate: Validator.name
                ))
                InputField(.init(
                    label: "Passwort",
                    value: "1234",
                    type: .Password
                ))
                InputField(.init(
                    label: "Nachricht",
                    type: .TextArea
                ))
           }
        }
    }
}
