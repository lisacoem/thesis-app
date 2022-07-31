//
//  FontModifier.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct FontTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(fontBold, size: fontSizeTitle))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorBlack)
    }
}

struct FontSubtitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(fontBold, size: fontSizeSubtitle))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorBlack)
    }
}

struct FontH1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(fontBold, size: fontSizeHeadline1))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorBlack)
    }
}

struct FontH2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(fontBold, size: fontSizeHeadline2))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorBlack)
    }
}

struct FontH3: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(fontBold, size: fontSizeHeadline3))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorBlack)
    }
}

struct FontH4: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(fontNormal, size: fontSizeHeadline3))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorBlack)
    }
}

struct FontText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(fontNormal, size: fontSizeText))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorBlack)
    }
}

struct FontLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(fontNormal, size: fontSizeLabel))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorBlack)
    }
}
