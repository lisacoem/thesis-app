//
//  SelectTeamView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 17.08.22.
//

import SwiftUI
import Combine

struct SelectTeamView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(teamService: TeamService) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(teamService: teamService)
        )
    }

    var body: some View {
        ScrollContainer {
            Text("Team finden")
                .modifier(FontTitle())
                .modifier(Header())
            
            SearchField(
                $viewModel.searchText,
                placeholder: "Postleitzahl"
            ) {
                viewModel.search()
            }
            
            if viewModel.teams.isEmpty {
                if let message = viewModel.message {
                    Text(message)
                        .foregroundColor(.customBrown)
                        .modifier(FontText())
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                }
            } else {
                ForEach(viewModel.teams, id: \.id) { team in
                    ListItem(
                        headline: team.name,
                        subline:
                            "\(team.zipcode) - " +
                            "\(team.userCount) Mitglieder"
                    )
                    .onTapGesture {
                        viewModel.join(team)
                    }
                }
            }
        }
    }
}

struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView(teamService: TeamMockService())
    }
}
