//
//  ButtonMenu.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 02.09.22.
//

import SwiftUI

struct ButtonMenu<Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        Menu {
            content()
        } label: {
            ZStack {
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
            }
            .foregroundColor(.customBlack)
            .spacing(.horizontal, .extraSmall)
            .aspectRatio(1/1, contentMode: .fit)
            .frame(height: 40, alignment: .center)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 8)
            )
        }
    }
}


struct ButtonNavigation_Previews: PreviewProvider {
    static var previews: some View {
        Container{
            HStack {
                ButtonBack()
                Spacer()
                ButtonMenu() {
                    Button(action: {}) {
                        Label("New Folder", systemImage: "folder.badge.plus")
                    }
                }
            }
        }
    }
}

