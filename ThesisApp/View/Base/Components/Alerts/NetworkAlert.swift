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
                .modifier(FontH5())
        }
        .padding(Spacing.small)
        .background(Color.customOrange)
        .cornerRadius(12)
    }
}

struct NetworkAlert_Previews: PreviewProvider {
    static var previews: some View {
        NetworkAlert()
    }
}
