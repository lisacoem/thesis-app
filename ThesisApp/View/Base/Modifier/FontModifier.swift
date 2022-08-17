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
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
}

struct FontSubtitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.subtitle))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
}

struct FontH1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.h1))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
}

struct FontH2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.h2))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
}

struct FontH3: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.bold, size: FontSize.h3))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
}

struct FontH4: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.normal, size: FontSize.h3))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
}

struct FontText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.normal, size: FontSize.text))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
}

struct FontLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.normal, size: FontSize.label))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
}
