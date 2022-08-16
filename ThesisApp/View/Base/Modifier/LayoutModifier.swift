//
//  LayoutModifier.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct ContainerLayout: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.screenWidth, alignment: .topLeading)
            .background(Color.background)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SectionLayout: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(
                EdgeInsets(
                    top: Spacing.extraLarge,
                    leading: Spacing.medium,
                    bottom: Spacing.extraLarge,
                    trailing: Spacing.medium
                )
            )
    }
}

struct ContentLayout: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(
                EdgeInsets(
                    top: Spacing.ultraLarge,
                    leading: Spacing.medium,
                    bottom: Spacing.extraLarge,
                    trailing: Spacing.medium
                )
            )
            .frame(minHeight: UIScreen.screenHeight, alignment: .topLeading)
    }
}
