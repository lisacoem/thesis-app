//
//  BackButton.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct ButtonBack: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(.ultraThinMaterial)
                .blur(radius: 15)
                .cornerRadius(8)
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.backward")
            }
            .background(.clear)
            .foregroundColor(colorBlack)
        }
        .frame(width: 25, height: 35, alignment: .center)
        
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBack()

    }
}
