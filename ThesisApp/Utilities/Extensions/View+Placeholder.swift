//
//  View+Placeholder.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

extension View {

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }

    
    func placeholder(_ text: String, when shouldShow: Bool, alignment: Alignment = .leading, color: Color = .customBeige) -> some View {
        placeholder(when: shouldShow, alignment: alignment) {
            Text(text)
                .foregroundColor(color)
                .modifier(FontText())
                .spacing(.horizontal, .extraSmall)
        }
    }
}
