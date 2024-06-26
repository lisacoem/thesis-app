//
//  ButtonIcon.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct ButtonIcon: View {
    var label: String
    var icon: String
    var disabled: Bool
    var action: () -> Void
    
    init(
        _ label: String,
        icon: String,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.disabled = disabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .spacing(.leading, .extraSmall)
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.customOrange)
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .foregroundColor(.customBlack)
                }
            }
            .modifier(FontH1())
            .spacing([.top, .bottom,], .small)
            .spacing([.leading, .trailing], .medium)
        }
        .background(Color.customBeige)
        .cornerRadius(35)
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1)
    }
}

struct ButtonIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonIcon(
                "Suchen",
                icon: "magnifyingglass",
                action: {}
            )
            ButtonIcon(
                "Suchen",
                icon: "magnifyingglass",
                disabled: true,
                action: {}
            )
        }
    }
}
