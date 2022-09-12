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
        var anyCancellable: Set<AnyCancellable>
        
        init(teamService: TeamService) {
            self.teamService = teamService
            self.anyCancellable = Set()
        }
    }
}

struct AchievementView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(teamService: TeamService) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(teamService: teamService)
        )
    }
    
    var body: some View {
        ScrollContainer {
            Text("Erfolge")
                .modifier(FontTitle())
                .modifier(HeaderLayout())
            
            ButtonLink("Vergleichen", icon: "arrow.right") {
                TeamRankingView(teamService: viewModel.teamService)
            }

        }
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView(teamService: TeamMockService())
    }
}
