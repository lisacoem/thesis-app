//
//  AchievementUnlockedModal.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.09.22.
//

import SwiftUI

extension View {
    
    func achievementModal(_ unlockedAchievements: Binding<[Achievement]?>) -> some View {
        self.overlay {
            if let achievements = unlockedAchievements.wrappedValue {
                AchievementUnlockedModal(achievements) {
                    unlockedAchievements.wrappedValue = nil
                }
            }
        }
    }
}

struct AchievementUnlockedModal: View {
    
    var achievements: [Achievement]
    var close: () -> Void
    
    init(_ achievements: [Achievement], close: @escaping () -> Void) {
        self.achievements = achievements
        self.close = close
        self.resetStyles()
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            TabView {
                ForEach(achievements, id: \.id) { achievement in
                    content(for: achievement)
                        .spacing(.all, .extraLarge)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(maxHeight: UIScreen.screenWidth * 0.8)
            .spacing(.bottom, .small)
            
            Button(action: close) {
                Image(systemName: "xmark")
                    .modifier(FontIconMedium())
                    .spacing([.top, .trailing], .medium)
            }
        }
        .frame(width: UIScreen.screenWidth * 0.8)
        .background(Color.background)
        .cornerRadius(18)
        .shadow(radius: 20)
    }
    
    func content(for achievement: Achievement) -> some View {
        VStack(spacing: .medium) {
            AsyncImage(url: achievement.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Circle()
                    .fill(Color.customOrange)
            }
            .frame(width: 120)
            .aspectRatio(1/1, contentMode: .fill)
            
            VStack(spacing: .ultraSmall) {
                Text(achievement.title)
                    .modifier(FontSubtitle())
                Text(achievement.content)
                    .modifier(FontText())
            }
        }
    }
}

