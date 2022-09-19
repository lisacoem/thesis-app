//
//  AchievementView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.09.22.
//

import SwiftUI

struct AchievementView: View {
    
    @FetchRequest var achievements: FetchedResults<Achievement>
    @StateObject var viewModel: ViewModel
    
    init(
        teamService: TeamService,
        achievementService: AchievementService,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                teamService: teamService,
                achievementService: achievementService,
                persistenceController: persistenceController
            )
        )
        self._achievements = FetchRequest(
            entity: Achievement.entity(),
            sortDescriptors: [
                NSSortDescriptor(
                    keyPath: \Achievement.unlocked,
                    ascending: false
                ),
                NSSortDescriptor(
                    keyPath: \Achievement.goal,
                    ascending: true
                )
            ],
            animation: .easeIn
        )
    }
    
    var body: some View {
        List {
            Section {
                ForEach(achievements) { achievement in
                    AchievementItem(achievement)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.background)
                }
            }
            header: {
                header
                    .spacing(.top, .extraLarge)
                    .spacing(.bottom, .large)
            }
        }
        .modifier(ListStyle())
        .refreshable {
            await self.viewModel.refresh()
        }
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: .large) {
            HStack {
                Text("Erfolge").modifier(FontTitle())
                Spacer()
                Points()
            }
            
            ButtonLink("Vergleichen", icon: "arrow.right") {
                RankingView(teamService: viewModel.teamService)
                    .navigationLink()
            }
            
            Text("Abzeichen")
                .modifier(FontSubtitle())
        }
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AchievementView(
                teamService: TeamMockService(),
                achievementService: AchievementMockService(),
                persistenceController: .preview
            )
        }
        .environment(
            \.managedObjectContext,
             PersistenceController.preview.container.viewContext
        )
    }
}
