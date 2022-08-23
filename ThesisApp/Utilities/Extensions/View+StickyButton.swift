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
                ButtonIcon(label, icon: icon, action: action)
                    .padding([.leading, .trailing], Spacing.medium)
                    .padding(.bottom, Spacing.extraLarge)
            }
        }
        .frame(
            width: UIScreen.screenWidth,
            height: UIScreen.screenHeight,
            alignment: .topLeading
        )
        .edgesIgnoringSafeArea(.all)
    }
}
