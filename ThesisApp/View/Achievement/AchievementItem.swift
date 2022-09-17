//
//  AchievementItem.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 13.09.22.
//

import SwiftUI

struct AchievementItem: View {
    
    @ObservedObject var achievement: Achievement
    
    init(_ achievement: Achievement) {
        self.achievement = achievement
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: .small) {
            ZStack {
                AsyncImage(url: achievement.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } placeholder: {
                    Circle()
                        .fill(Color.customOrange)
                        .frame(width: 50)
                }
            }
            VStack(alignment: .leading, spacing: .ultraSmall) {
                Text(achievement.title)
                    .modifier(FontH1())
                    .multilineTextAlignment(.leading)
                Text(achievement.content)
                    .modifier(FontText())
                    .multilineTextAlignment(.leading)
            }
        }
        .opacity(achievement.unlocked ? 1 : 0.5)
    }
}
