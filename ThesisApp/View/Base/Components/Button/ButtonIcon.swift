//
//  ButtonIcon.swift
//  components
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
            Group {
                HStack {
                    Text(label)
                        .font(.custom(fontBold, size: fontSizeHeadline1))
                        .foregroundColor(colorBlack)
                    Spacer()
                    ZStack {
                        Circle().fill(colorOrange)
                            .frame(width: 40, height: 40)
                        Image(systemName: icon)
                            .font(.custom(fontBold, size: fontSizeHeadline1))
                            .foregroundColor(colorBlack)
                    }
                }
                .padding([.top, .bottom,], 15)
                .padding(.trailing, 20)
                .padding(.leading, 30)
            }
        }
        .background(colorBeige)
        .cornerRadius(35)
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1)
    }
}

struct ButtonIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonIcon("Suchen", icon: "magnifyingglass", action: {})
            ButtonIcon("Suchen", icon: "magnifyingglass", disabled: true, action: {})
        }
    }
}
