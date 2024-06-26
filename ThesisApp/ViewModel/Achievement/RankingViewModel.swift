//
//  RankingViewModel.swift
//  ThesisApp
//
//  ViewModel of RankingView
//
//  Created by Lisa Wittmann on 18.09.22.
//

import SwiftUI
import Combine

extension RankingView {
    
    class ViewModel: ObservableObject {
        
        @Published var teamResult: TeamResultData?
        @Published var results: [TeamResultData]

        @Published var disconnected: Bool
        
        private let teamService: TeamService
        
        private var cancellables: Set<AnyCancellable>
        
        init(teamService: TeamService) {
            self.teamService = teamService
            self.cancellables = Set()
            self.results = []
            self.disconnected = false
            self.loadResults()
        }
        
        /// Get ranking data from API and store it in ViewModel.
        /// Add  a network warning if user is disconnected
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
                    receiveValue: resolve
                )
                .store(in: &cancellables)
        }
        
        /// Update ranking data async to provide pull to refresh in view
        func refresh() async {
            do {
                let response = try await teamService.getRanking().async()
                resolve(response)
            } catch {
                if let error = error as? ApiError {
                    self.disconnected = error == .unavailable
                }
            }
        }
        
        /// Store ranking data from API in ViewModel and sort results by rank
        /// - Parameter response: API response data
        func resolve(_ response: TeamRankingData) {
            self.disconnected = false
            self.teamResult = response.team
            self.results = response.ranking.sorted()
        }
        
        /// Check if the result is from logged in users team
        /// - Parameter result: team result to verify
        /// - Returns: true if the result is from users team, false otherwise
        func isTeam(_ result: TeamResultData) -> Bool {
            guard let team = self.teamResult else {
                return false
            }
            return team.id == result.id
        }
    }
}
