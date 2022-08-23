//
//  ButtonLink.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import SwiftUI

struct ButtonLink<Content: View>: View {
    
    @State var isActive = false
    
    var label: String
    var icon: String
    var destination: () -> Content
    
    init(
        _ label: String,
        icon: String,
        destination: @escaping () -> Content
    ) {
        self.label = label
        self.icon = icon
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(isActive: $isActive, destination: destination) {
            ButtonIcon(label, icon: icon, action: { isActive = true })
        }
    }
}
