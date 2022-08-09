//
//  HomeView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Container {
            HStack(alignment: .center, spacing: spacingMedium) {
                Text("Headline")
                    .modifier(FontTitle())
                Points(26)
            }
            Spacer()
            
            Spacer()
            
            ButtonIcon("Punkte eintauschen", icon: "plus", action: {})
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
