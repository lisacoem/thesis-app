//
//  AchievementView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.09.22.
//

import SwiftUI
import Combine

extension AchievementView {
    
    class ViewModel: ObservableObject {
        
        let teamService: TeamService
        let achievementService: AchievementService
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            teamService: TeamService,
            achievementService: AchievementService
        ) {
            self.achievementService = achievementService
            self.teamService = teamService
            self.anyCancellable = Set()
        }
    }
}

struct AchievementView: View {
    
    @FetchRequest var achievements: FetchedResults<Achievement>
    @StateObject var viewModel: ViewModel
    
    
    init(
        teamService: TeamService,
        achievementService: AchievementService
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                teamService: teamService,
                achievementService: achievementService
            )
        )
        self._achievements = FetchRequest(entity: Achievement.entity(), sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Achievement.goal,
                ascending: true
            )
        ])
    }
    
    var body: some View {
        List {
            Section {
                ForEach(achievements) { achievement in
                    AchievementItem(achievement)
                }
            }
            header: {
                header
                    .spacing(.top, .extraLarge)
            }
        }
        .modifier(ListStyle())
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: .large) {
            Text("Erfolge")
                .modifier(FontTitle())
            
            ButtonLink("Vergleichen", icon: "arrow.right") {
                RankingView(teamService: viewModel.teamService)
            }
            
            Text("Abzeichen")
                .modifier(FontSubtitle())
        }
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView(
            teamService: TeamMockService(),
            achievementService: AchievementMockService()
        )
    }
}
