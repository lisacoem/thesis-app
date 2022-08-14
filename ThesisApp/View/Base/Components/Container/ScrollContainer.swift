//
//  ScrollContainer.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import SwiftUI

struct ScrollContainer<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large, content: content)
                .modifier(ContentLayout())
        }.modifier(ContainerLayout())
    }
}

struct ScrollContainer_Previews: PreviewProvider {
    static var previews: some View {
        ScrollContainer {
            Text("Test")
        }
    }
}
