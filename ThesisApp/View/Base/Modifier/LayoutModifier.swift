//
//  LayoutModifier.swift
//  ThesisApp
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
                    top: .ultraLarge,
                    leading: .medium,
                    bottom: .extraLarge,
                    trailing: .medium
                )
            )
    }
}

struct HeaderLayout: ViewModifier {
    func body(content: Content) -> some View {
        content.spacing(.top, .medium)
    }
}
