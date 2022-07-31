//
//  View+StickyButton.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import Foundation
import SwiftUI

extension View {
    
    func stickyButton(_ label: String, icon: String, action: @escaping () -> Void) -> some View {
        ZStack {
            self
            VStack {
                Spacer()
                Group {
                    ButtonIcon(label, icon: icon, action: action)
                        .padding([.leading, .trailing], spacingMedium)
                        .padding(.top, 100)
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [colorBackground, colorBackground.opacity(0)]),
                        startPoint: .bottom, endPoint: .top
                    )
                )
            }

        }
    }
}
