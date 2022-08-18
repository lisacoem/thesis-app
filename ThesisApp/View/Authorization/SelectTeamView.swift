//
//  SelectTeamView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 17.08.22.
//

import SwiftUI

extension SelectTeamView {
    
    class ViewModel: ObservableObject {
        @Published var searchText: String
        
        @Published var teams: [TeamData]
        @Published var selectedTeam: TeamData?
        
        private let authorizationService: AuthorizationService
        
        init(authorizatinService: AuthorizationService) {
            self.authorizationService = authorizatinService
            self.searchText = ""
            self.selectedTeam = nil
            self.teams = []
        }
        
        func search() {
            print(self.searchText)
            authorizationService.searchTeams(by: self.searchText)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { teams in self.teams = teams }
                )
        }
    }
}

struct SelectTeamView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(authorizationService: AuthorizationService) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(authorizatinService: authorizationService)
        )
    }

    var body: some View {
        Container {
            Text("Team finden")
                .modifier(FontTitle())
            
            SearchField(
                $viewModel.searchText,
                placeholder: "Postleitzahl"
            ) {
                viewModel.search()
            }
            
            if !viewModel.teams.isEmpty {
                ForEach(viewModel.teams, id: \.id) { team in
                    ListItem(
                        headline: team.name,
                        subline:
                            "\(team.zipcode) - " +
                            "\(team.userCount) Mitglieder"
                    )
                }
            }
            
            
        }
    }
}

struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView(
            authorizationService: WebAuthorizationService()
        )
    }
}
