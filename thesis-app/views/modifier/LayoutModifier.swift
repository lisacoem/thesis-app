//
//  LayoutModifier.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct PageLayout: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: screenWidth, alignment: .topLeading)
            .background(colorBackground)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SectionLayout: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(
                EdgeInsets(
                    top: spacingExtraLarge,
                    leading: spacingMedium,
                    bottom: spacingExtraLarge,
                    trailing: spacingMedium
                )
            )
    }
}

struct ContentLayout: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(
                EdgeInsets(
                    top: spacingExtraLarge,
                    leading: spacingMedium,
                    bottom: spacingExtraLarge,
                    trailing: spacingMedium
                )
            )
            .frame(minHeight: screenHeight, alignment: .topLeading)
    }
}
