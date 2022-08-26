//
//  View+ResetStyles.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import SwiftUI

extension View {
    
    func resetStyles() {
        let transparentAppearence = UINavigationBarAppearance()
        transparentAppearence.configureWithTransparentBackground()
        
        let appearance = UINavigationBar.appearance()
        appearance.standardAppearance = transparentAppearence
        appearance.scrollEdgeAppearance = transparentAppearence
        appearance.compactAppearance = transparentAppearence
        
        UITextView.appearance().backgroundColor = .clear
    }
}
