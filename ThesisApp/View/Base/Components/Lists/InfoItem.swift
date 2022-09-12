//
//  InfoItem.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 17.08.22.
//

import SwiftUI

struct InfoItem: View {
    
    var symbol: String
    var value: String
    
    init(symbol: String, value: String) {
        self.symbol = symbol
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: .ultraSmall) {
            Image(systemName: symbol)
                .modifier(FontIconLarge())
                .foregroundColor(.black)
                
            Text(value)
                .modifier(FontHighlight())
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .large) {
            InfoItem(symbol: "clock", value: "01:45:31")
            InfoItem(symbol: Movement.cycling.symbol, value: "32,60 km")
        }
    }
}
