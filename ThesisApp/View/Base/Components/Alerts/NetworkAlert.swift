//
//  NetworkAlert.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import SwiftUI

struct NetworkAlert: View {
    var body: some View {
        HStack(spacing: Spacing.extraSmall) {
            Image(systemName: "wifi.slash")
                .foregroundColor(.customBlack)
                .frame(width: IconSize.medium, height: IconSize.medium)
            
            Text("Keine Netzwerkverbindung")
                .foregroundColor(Color.customBlack)
                .font(.custom(Font.bold, size: FontSize.text))
        }
        .padding(15)
        .background(Color.customOrange.cornerRadius(12))
        .padding(.horizontal, 15)
    }
}

struct NetworkAlert_Previews: PreviewProvider {
    static var previews: some View {
        NetworkAlert()
    }
}
