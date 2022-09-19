//
//  SelectTeamViewModel.swift
//  ThesisApp
//
//  ViewModel of SelectTeamView
//
//  Created by Lisa Wittmann on 23.08.22.
//

import SwiftUI
import Combine

extension SelectTeamView {
    
    class ViewModel: ObservableObject {
        
        @Published var searchText: String
        @Published var message: String?
        
        @Published var teams: [TeamData]
        
        private let teamService: TeamService
        
        var cancellables: Set<AnyCancellable>
        
        init(teamService: TeamService) {
            self.teamService = teamService
            self.searchText = ""
            self.teams = []
            self.cancellables = Set()
        }
        
        /// get teams by entered search param and store them in view model
        func search() {
            self.message = "Loading..."
            teamService.searchTeams(by: self.searchText)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            print("loaded teams")
                        case .failure(_):
                            self.message = "Es ist ein Fehler aufgetreten"
                        }
                    },
                    receiveValue: resolve
                )
                .store(in: &cancellables)
        }
        
        /// store teams in view model and update message
        /// - Parameter response: api response data
        func resolve(_ response: [TeamData]) {
            self.teams = response
            if teams.isEmpty {
                self.message = "Keine Teams gefunden"
            } else {
                self.message = nil
            }
        }
        
        /// add user to selected team and update authentication state
        /// - Parameter teamData: selected team
        func join(_ teamData: TeamData) {
            teamService.joinTeam(teamData)
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { team in
                        UserDefaults.standard.set(false, for: .isTeamRequired)
                    }
                )
                .store(in: &cancellables)
        }
    }
}

