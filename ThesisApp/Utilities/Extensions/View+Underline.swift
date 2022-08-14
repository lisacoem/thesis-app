//
//  View+Underline.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

extension View {
    
    func underline(height: CGFloat = 2.5, color: Color = .orange, opacity: Double = 0.7) -> some View {
            self.overlay(
                    Rectangle()
                        .frame(height: height)
                        .padding(.top, 45)
                        .opacity(opacity)
                )
                .foregroundColor(color)
                .padding([.top, .bottom], Spacing.extraSmall)
    }
}
