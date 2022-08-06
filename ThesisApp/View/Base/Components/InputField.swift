//
//  InputField.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct InputField: View {
    @Binding var text: String
    var label: String
    var placeholder: String
    var secure: Bool = false
    var validate: ((String) -> Bool)?
    
    @State var error = false
    
    init(_ label: String, placeholder: String = "", text: Binding<String>, secure: Bool = false, validate: ((String) -> Bool)? = nil) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.secure = secure
        self.validate = validate
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(label)
                .font(.custom(fontBold, size: fontSize))
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                if secure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .foregroundColor(colorBlack)
            .font(.custom(fontNormal, size: 14))
            .placeholder(placeholder, when: text.isEmpty)
            .underline(color: colorBeige)
        }
    }
    
    let fontSize: CGFloat = 16
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: spacingLarge) {
           InputField("E-Mail", placeholder: "example@mail.com", text: .constant(""), secure: false)
            InputField("Nutzername", text: .constant("Nutzername123"), secure: false)
       }.padding()
    }
}
