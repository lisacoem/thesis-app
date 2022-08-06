//
//  View+Underline.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

extension View {
    
    func underline(height: CGFloat = 2, color: Color = colorOrange, opacity: Double = 0.5) -> some View {
            self.overlay(
                    Rectangle()
                        .frame(height: height)
                        .padding(.top, 55)
                        .opacity(opacity)
                )
                .foregroundColor(color)
                .padding([.top, .bottom], spacingExtraSmall)
    }
}
