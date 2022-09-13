//
//  Layout.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import SwiftUI

extension UIScreen {
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
}


enum Spacing: CGFloat, CaseIterable {
    
    case ultraSmall = 5,
         extraSmall = 10,
         small = 15,
         medium = 20,
         large = 35,
         extraLarge = 60,
         ultraLarge = 80
}

