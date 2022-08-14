//
//  Container.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import SwiftUI

struct Container<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack {
            VStack(spacing: Spacing.large, content: content)
                .modifier(ContentLayout())
        }.modifier(ContainerLayout())
    }
}

struct Container_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            Text("Test")
        }
    }
}
