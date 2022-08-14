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
                .font(.custom(Font.bold, size: FontSize.text))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)

            Group {
                switch model.type {
                case .Text:
                    TextField("", text: $model.value)
                        .textContentType(model.contentType)
                case .Email:
                    TextField("", text: $model.value)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                case .Password:
                    SecureField("", text: $model.value)
                case .TextArea:
                    TextEditor(text: $model.value)
                        .frame(minHeight: 0, maxHeight: 150)
                }
            }
            .padding([.top, .bottom], Spacing.small)
            .padding([.leading, .trailing], 5)
            .foregroundColor(valid ? .black : .red)
            .background(Color.lightBeige)
            .font(.custom(Font.normal, size: FontSize.text))
            .onChange(of: model.value) { value in
                valid = model.validate(value)
            }

            Rectangle()
                .frame(height: 2.5)
                .foregroundColor(.lightBrown)
                .opacity(0.7)
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            VStack(spacing: Spacing.large) {
                InputField(.init(
                    label: "E-Mail",
                    contentType: .emailAddress,
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
