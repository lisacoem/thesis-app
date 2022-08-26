//
//  FieldDetailView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import SwiftUI

struct FieldDetailView: View {
    
    var daytime: Daytime
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: daytime.colors,
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(
                alignment: .leading,
                spacing: Spacing.large
            ) {
                header
                Spacer()
                ButtonIcon("Punkte eintauschen", icon: "plus") {}
            }
            .modifier(ContentLayout())
        }
        .ignoresSafeArea()
    }
    
    var header: some View {
        HStack(alignment: .top) {
            fieldName
            Spacer()
            Points(25)
        }
        .modifier(Header())
    }
    
    var fieldName: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Biohof Günther")
                .foregroundColor(daytime == .night
                     ? .background
                     : .customBlack
                )
                .modifier(FontTitle())
            Text("Außerhalb 2")
                .foregroundColor(daytime == .night
                     ? .background
                     : .customBlack
                )
                .modifier(FontH4())
        }
    }
}

struct FieldDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FieldDetailView(daytime: .twilight)
        FieldDetailView(daytime: .midday)
        FieldDetailView(daytime: .night)
    }
}
