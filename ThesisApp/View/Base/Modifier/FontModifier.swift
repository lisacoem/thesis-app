//
//  FontModifier.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct FontTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.bold, size: .title))
            .foregroundColor(.customBlack)
    }
}

struct FontSubtitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.bold, size: .subtitle))
            .foregroundColor(.customBlack)
    }
}

struct FontH1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.bold, size: .h1))
            .foregroundColor(.customBlack)
    }
}

struct FontH2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.bold, size: .h2))
            .foregroundColor(.customBlack)
    }
}


struct FontH3: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.bold, size: .h3))
            .foregroundColor(.customBlack)
    }
}

struct FontH4: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.normal, size: .h3))
            .foregroundColor(.customBlack)
    }
}

struct FontH5: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.bold, size: .text))
            .foregroundColor(.customBlack)
    }
}

struct FontHighlight: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.bold, size: .highlight))
            .foregroundColor(.customBlack)
    }
}

struct FontText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.normal, size: .text))
            .foregroundColor(.customBlack)
    }
}


struct FontLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.normal, size: .label))
            .foregroundColor(.customBlack)
    }
}

struct FontIconMedium: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.normal, size: IconSize.medium))
            .foregroundColor(.customBlack)
    }
}

struct FontIconLarge: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.bold, size: IconSize.large))
            .foregroundColor(.customBlack)
    }
}



