//
//  PolyfillModifier.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 12.09.22.
//

import Foundation
import SwiftUI

struct BackgroundPolyfill: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}
