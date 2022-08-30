//
//  SelectTeamViewModel.swift
//  ThesisApp
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
        
        var anyCancellable: Set<AnyCancellable>
        
        init(teamService: TeamService) {
            self.teamService = teamService
            self.searchText = ""
            self.teams = []
            self.anyCancellable = Set()
        }
        
        func search() {
            self.message = "Loading..."
            teamService.searchTeams(by: self.searchText)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { teams in
                        self.teams = teams
                        if teams.isEmpty {
                            self.message = "Keine Teams gefunden"
                        } else {
                            self.message = nil
                        }
                    }
                )
                .store(in: &anyCancellable)
        }
        
        func join(_ teamData: TeamData) {
            teamService.joinTeam(teamData)
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { team in
                        UserDefaults.standard.set(false, for: .isTeamRequired)
                    }
                )
                .store(in: &anyCancellable)
        }
    }
}

