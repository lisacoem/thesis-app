//
//  SearchField.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 17.08.22.
//

import SwiftUI

struct SearchField: View {
    
    @Binding var value: String
    
    var placeholder: String
    var onSubmit: () -> Void
    
    init(
        _ value: Binding<String>,
        placeholder: String,
        onSubmit: @escaping () -> Void
    ) {
        self._value = value
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                TextField("", text: $value)
                    .modifier(FontText())
                    .spacing([.top, .bottom], .small)
                    .spacing([.leading, .trailing], .extraSmall)
                    .placeholder(placeholder, when: value.isEmpty)
                    .onSubmit {
                        onSubmit()
                    }
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.customLightBrown)
                    .spacing(.trailing, .extraSmall)
                    .onTapGesture { onSubmit() }
            }

            Rectangle()
                .frame(height: 2.5)
                .foregroundColor(.customLightBrown)
                .opacity(0.7)
        }
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(.constant("55422"), placeholder: "Postleitzahl") {}
    }
}
