//
//  View+Spacing.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 13.09.22.
//

import Foundation
import SwiftUI

extension View {

    func spacing(_ edges: Edge.Set = .all, _ length: Spacing, negated: Bool = false) -> some View {
        self.padding(edges, negated ? length.rawValue * (-1) : length.rawValue)
    }
}

extension VStack {

    init(alignment: HorizontalAlignment = .center, spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}

extension HStack {

    init(alignment: VerticalAlignment = .center, spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}

extension EdgeInsets {

    init(top: Spacing, leading: Spacing, bottom: Spacing, trailing: Spacing) {
        self.init(top: top.rawValue, leading: leading.rawValue, bottom: bottom.rawValue, trailing: trailing.rawValue)
    }
}
