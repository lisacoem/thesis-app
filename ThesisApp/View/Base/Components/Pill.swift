//
//  Pill.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 22.08.22.
//

import SwiftUI

struct Pill: View {
    
    var value: String
    var selected: Bool
    
    init(_ value: String, selected: Bool = false) {
        self.value = value
        self.selected = selected
    }
    
    var body: some View {
        Text(value)
            .modifier(FontText())
            .spacing([.leading, .trailing], .small)
            .spacing([.top, .bottom], .ultraSmall)
            .background(selected ? Color.customOrange : Color.customBeige)
            .cornerRadius(12)
    }
}


struct Pill_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Pill("Event")
            Pill("Party", selected: true)
        }
    }
}
