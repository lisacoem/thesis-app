//
//  View+Sticky.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.07.22.
//

import Foundation
import SwiftUI

extension View {

    func sticky<Content: View>(_ content: @escaping () -> Content) -> some View {
        ZStack {
            self
            VStack {
                Spacer()
                ZStack {
                    content()
                        .spacing(.horizontal, .medium)
                        .spacing(.bottom, .extraLarge)
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color.background,
                                Color.background.opacity(0)
                            ]
                        ),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
               
            }
        }
        .frame(
            width: UIScreen.screenWidth,
            alignment: .topLeading
        )
        .frame(maxHeight: UIScreen.screenHeight)
        .edgesIgnoringSafeArea(.all)
    }
}
