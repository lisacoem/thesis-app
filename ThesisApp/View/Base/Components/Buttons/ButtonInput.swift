//
//  ButtonInput.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import SwiftUI

struct ButtonInput: View {
    
    @Binding var text: String
    var placeholder: String
    
    var icon: String
    var action: () -> Void
    
    init(
        _ text: Binding<String>,
        placeholder: String,
        icon: String,
        action: @escaping () -> Void
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        ZStack {
            HStack {
                TextField(placeholder, text: $text)
                    .spacing(.leading, .extraSmall)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button(action: action) {
                    ZStack {
                        Circle()
                            .fill(Color.customOrange)
                            .frame(width: 40, height: 40)
                        Image(systemName: icon)
                            .foregroundColor(.customBlack)
                    }
                }
            }
            .modifier(FontH1())
            .spacing([.top, .bottom,], .small)
            .spacing([.leading, .trailing], .medium)
        }
        .background(Color.customBeige)
        .cornerRadius(35)
    }
}

struct ButtonInput_Previews: PreviewProvider {
    static var previews: some View {
        ButtonInput(
            .constant(""),
            placeholder: "Kommentar schreiben",
            icon: "plus",
            action: {}
        )
    }
}
