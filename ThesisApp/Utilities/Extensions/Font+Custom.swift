//
//  Font+Custom.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 13.09.22.
//

import Foundation
import SwiftUI

extension Font {

    static func custom(_ name: FontName, size: CGFloat) -> Font {
        return .custom(name.rawValue, size: size)
    }
    
    static func custom(_ name: FontName, size: FontSize) -> Font {
        return .custom(name.rawValue, size: size.rawValue)
    }
}
