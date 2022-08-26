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
            .frame(
                minWidth: UIScreen.screenWidth,
                minHeight: UIScreen.screenHeight,
                alignment: .topLeading
            )
            .background(Color.background)
            .edgesIgnoringSafeArea(.all)
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
    }
}


struct Header: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.top, Spacing.medium)
    }
}
