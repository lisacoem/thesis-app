//
//  View+NavigationBarStyle.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 16.08.22.
//

import SwiftUI

extension View {
    
    func transparentNavigationBar() {
        let transparentAppearence = UINavigationBarAppearance()
        transparentAppearence.configureWithTransparentBackground()
        
        let appearance = UINavigationBar.appearance()
        appearance.standardAppearance = transparentAppearence
        appearance.scrollEdgeAppearance = transparentAppearence
        appearance.compactAppearance = transparentAppearence
    }
}
