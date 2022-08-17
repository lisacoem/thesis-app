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
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.backward")
                .resizable()
                .scaledToFit()
        }
        .foregroundColor(.customBlack)
        .padding(.leading, 11)
        .padding(.trailing, 9)
        .padding([.top, .bottom], 5)
        .frame(height: 40, alignment: .center)
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
