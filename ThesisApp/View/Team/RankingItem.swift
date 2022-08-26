//
//  RankingItem.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 25.08.22.
//

import SwiftUI

struct RankingItem: View {
    
    var team: TeamResult
    var highlighted: Bool
    
    init(
        _ team: TeamResult,
        highlighted: Bool = false
    ) {
        self.team = team
        self.highlighted = highlighted
    }
    
    var body: some View {
        HStack {
            Text("\(team.rank)")
                .font(.custom(Font.normal, size: FontSize.title))
                .frame(width: 75, alignment: .leading)
            
            VStack(alignment: .leading, spacing: Spacing.ultraSmall) {
                Text(team.name)
                    .font(.custom(Font.normal, size: FontSize.h2))
                
                Text("\(Formatter.double(team.distance)) km")
                    .modifier(FontH5())
            }
            
            Spacer()
        }
        .frame(height: 65)
        .padding()
        .background(
            highlighted ? Color.customOrange : Color.customLightBeige
        )
        .cornerRadius(20)
    }
}

struct RankingItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RankingItem(
                TeamResult(
                    id: 0,
                    name: "Ingelheim",
                    zipcode: "55422",
                    distance: 8134.32,
                    rank: 1
                )
            )
            RankingItem(
                TeamResult(
                    id: 1,
                    name: "Bacharach",
                    zipcode: "55422",
                    distance: 8134.32,
                    rank: 2
                ),
                highlighted: true
            )
        }
    }
}
