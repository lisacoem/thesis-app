//
//  InputField.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct InputField: View {
    
    @ObservedObject var model: InputFieldModel
    @FocusState var focusField: InputFieldModel?
    @State var valid = true
    
    init(
        _ model: InputFieldModel,
        focusField: FocusState<InputFieldModel?>
    ) {
        self.model = model
        self._focusField = focusField
        self.resetStyles()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .ultraSmall) {
            label
            VStack(spacing: 0) {
                field
                border
            }
        }
    }
    
    var label: some View {
        Text(model.label)
            .modifier(FontH5())
    }
    
    var field: some View {
        Group {
            switch model.type {
            case .text:
                TextField("", text: $model.value)
                    .textContentType(model.contentType)
                
            case .email:
                TextField("", text: $model.value)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
            case .password:
                SecureField("", text: $model.value)
                
            case .textArea:
                TextEditor(text: $model.value)
                    .frame(height: 150)
                    .modifier(BackgroundPolyfill())
            }
        }
        .focused($focusField, equals: model)
        .onChange(of: model.value) { value in
            valid = model.validate(value)
        }
        .spacing(.vertical, .small)
        .spacing(.horizontal, .extraSmall)
        .background(Color.customLightBeige)
        .foregroundColor(valid ? .customBlack : .customRed)
        .modifier(FontText())
    }
    
    var border: some View {
        Rectangle()
            .frame(height: 2.5)
            .foregroundColor(.customLightBrown)
            .opacity(0.7)
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            VStack(spacing: .large) {
                InputField(
                    .init(
                        label: "E-Mail",
                        contentType: .emailAddress,
                        validate: Validator.mail
                    ),
                    focusField: FocusState()
                )
                InputField(
                    .init(
                        label: "Nutzername",
                        value: "Nutzername123",
                        validate: Validator.name
                    ),
                    focusField: FocusState()
                )
                InputField(
                    .init(
                        label: "Passwort",
                        value: "1234",
                        type: .password
                    ),
                    focusField: FocusState()
                )
                InputField(
                    .init(
                        label: "Nachricht",
                        type: .textArea
                    ),
                    focusField: FocusState()
                )
           }
        }
    }
}
