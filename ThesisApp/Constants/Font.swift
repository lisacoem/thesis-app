//
//  Font.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import SwiftUI

enum FontName: String, CaseIterable {
    case bold = "KelsonSans-Bold",
         normal = "KelsonSans-Normal",
         light = "KelsonSans-Light"
}

enum FontSize: CGFloat, CaseIterable {
    case title = 40,
         subtitle = 25,
         h1 = 20,
         h2 = 18,
         h3 = 16,
         text = 14,
         highlight = 26,
         label = 12
}

enum IconSize {
    static let large: CGFloat = 30
    static let medium: CGFloat = 22
}
