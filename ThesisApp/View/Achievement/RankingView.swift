//
//  RankingView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 25.08.22.
//

import SwiftUI
import Combine

struct RankingView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(teamService: TeamService) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(teamService: teamService)
        )
    }
    
    var body: some View {
        ScrollContainer {
            if let team = viewModel.teamResult {
                header(for: team)
                    .spacing(.top, .small)
            }
            
            VStack(spacing: .small) {
                ForEach(viewModel.results) { result in
                    RankingItem(
                        result,
                        highlighted: viewModel.isTeam(result)
                    )
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .networkAlertModal(isPresented: $viewModel.disconnected)
    }
    
    func header(for team: TeamResultData) -> some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: .ultraSmall) {
                Text(team.name)
                    .font(.custom(.normal, size: 30))
                    .foregroundColor(.customBlack)
                
                HStack(alignment: .bottom, spacing: .ultraSmall) {
                    Text("\(Formatter.double(team.distance))")
                        .modifier(FontTitle())
                    Text("km")
                        .modifier(FontH3())
                        .padding(.bottom, 6)
                }
            }
            
            Spacer()
            
            if let rank = team.rank {
                Text("\(rank).")
                    .font(.custom(.bold, size: 60))
                    .foregroundColor(.customOrange)
            }
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(teamService: TeamMockService())
    }
}
