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
        VStack {
            Image(systemName: symbol)
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
                .frame(height: IconSize.large)
                .font(.custom(Font.bold, size: IconSize.large))
                .foregroundColor(.black)
                
            Text(value)
                .font(.custom(Font.bold, size: FontSize.highlight))
                .multilineTextAlignment(.center)
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
        }
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InfoItem(symbol: "clock", value: "01:45:31")
            InfoItem(symbol: Movement.cycling.symbol, value: "32,60 km")
        }
    }
}
