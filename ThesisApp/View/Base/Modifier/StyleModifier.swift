//
//  StyleModifier.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 12.09.22.
//

import Foundation
import SwiftUI

struct ListStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listStyle(.plain)
            .modifier(ContainerLayout())
            .modifier(BackgroundPolyfill())
            .environment(\.defaultMinListRowHeight, 75)
    }
}
