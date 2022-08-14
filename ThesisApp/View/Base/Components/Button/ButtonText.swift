//
//  ButtonText.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.08.22.
//

import SwiftUI

struct ButtonText: View {
    
    var label: String
    var action: () -> Void
    
    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom(Font.bold, size: FontSize.h3))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ButtonText_Previews: PreviewProvider {
    static var previews: some View {
        ButtonText("Jetzt registrieren") {}
    }
}
