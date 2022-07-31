//
//  PlantingView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI

struct PlantingView: View {
    var body: some View {
        Page {
            HStack(alignment: .top, spacing: spacingMedium) {
                VStack(spacing: spacingSmall) {
                    Text("BIOHOF GÜNTHER")
                        .modifier(FontTitle())
                    Text("Außerhalb 2")
                        .modifier(FontH4())
                }
                Points(26)
            }
            Spacer()
            
            ButtonIcon("Punkte eintauschen", icon: "plus", action: {})
        }
    }
}

struct PlantingView_Previews: PreviewProvider {
    static var previews: some View {
        PlantingView()
    }
}
