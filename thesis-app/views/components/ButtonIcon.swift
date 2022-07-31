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
    var action: () -> Void
    
    init(_ label: String, icon: String, action: @escaping () -> Void) {
        self.label = label
        self.icon = icon
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
    }
}

struct ButtonIcon_Previews: PreviewProvider {
    static var previews: some View {
        ButtonIcon("Suchen", icon: "magnifyingglass", action: {})
    }
}
