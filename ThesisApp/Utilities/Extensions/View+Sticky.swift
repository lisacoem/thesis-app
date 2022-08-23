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
                content()
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
