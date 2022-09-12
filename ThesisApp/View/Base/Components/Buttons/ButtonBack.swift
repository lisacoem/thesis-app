//
//  BackButton.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct ButtonBack: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.backward")
                .resizable()
                .scaledToFit()
        }
        .foregroundColor(.customBlack)
        .padding(.leading, 11)
        .padding(.trailing, 9)
        .spacing(.vertical, .ultraSmall)
        .frame(width: 40, height: 40, alignment: .center)
        .aspectRatio(1/1, contentMode: .fit)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 8)
        )
        
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            ButtonBack()
        }
    }
}
