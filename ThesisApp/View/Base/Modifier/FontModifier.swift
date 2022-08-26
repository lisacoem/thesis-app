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
            .font(.custom(Font.bold, size: FontSize.title))
            .foregroundColor(.customBlack)
    }
}

struct FontSubtitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.subtitle))
            .foregroundColor(.customBlack)
    }
}

struct FontH1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.h1))
            .foregroundColor(.customBlack)
    }
}

struct FontH2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.h2))
            .foregroundColor(.customBlack)
    }
}


struct FontH3: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.h3))
            .foregroundColor(.customBlack)
    }
}

struct FontH4: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.normal, size: FontSize.h3))
            .foregroundColor(.customBlack)
    }
}

struct FontH5: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.text))
            .foregroundColor(.customBlack)
    }
}

struct FontHighlight: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.highlight))
            .foregroundColor(.customBlack)
    }
}

struct FontText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.normal, size: FontSize.text))
            .foregroundColor(.customBlack)
    }
}


struct FontLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.normal, size: FontSize.label))
            .foregroundColor(.customBlack)
    }
}

struct FontIconMedium: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.normal, size: IconSize.medium))
            .foregroundColor(.customBlack)
    }
}

struct FontIconLarge: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: IconSize.large))
            .foregroundColor(.customBlack)
    }
}



