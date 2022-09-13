//
//  TeamRankingView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 25.08.22.
//

import SwiftUI
import Combine

extension RankingView {
    
    class ViewModel: ObservableObject {
        
        @Published var teamResult: TeamResultData?
        @Published var results: [TeamResultData]
        @Published var disconnected: Bool
        
        var anyCancellable: Set<AnyCancellable>
        
        private let teamService: TeamService
        
        init(teamService: TeamService) {
            self.teamService = teamService
            self.anyCancellable = Set()
            self.results = []
            self.disconnected = false
            self.loadResults()
        }
        
        func loadResults() {
            teamService.getRanking()
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            self.disconnected = false
                        case .failure(let error):
                            self.disconnected = error == .unavailable
                        }
                    },
                    receiveValue: { data in
                        print(data)
                        self.teamResult = data.team
                        self.results = data.ranking.sorted()
                    }
                )
                .store(in: &anyCancellable)
        }
        
        func refresh() async {
            do {
                let data = try await teamService.getRanking().async()
                self.teamResult = data.team
                self.results = data.ranking.sorted()
            } catch {
                print(error)
            }
        }
        
        func isTeam(_ result: TeamResultData) -> Bool {
            guard let team = self.teamResult else {
                return false
            }
            return team.id == result.id
        }
    }
}

struct RankingView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(teamService: TeamService) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(teamService: teamService)
        )
    }
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.results) { result in
                    RankingItem(
                        result,
                        highlighted: viewModel.isTeam(result)
                    )
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.background)
            }
            header: {
                VStack {
                    if let team = viewModel.teamResult {
                        header(for: team)
                    }
                }
                .spacing(.top, .extraLarge)
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .modifier(ListStyle())
        .networkAlert(isPresented: $viewModel.disconnected)
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
        .spacing(.bottom, .medium)
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(teamService: TeamMockService())
    }
}
