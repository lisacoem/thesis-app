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
    
    init(
        session: Session,
        teamService: TeamService,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                session: session,
                teamService: teamService,
                persistenceController: persistenceController)
        )
    }

    var body: some View {
        ScrollContainer {
            Text("Team finden")
                .modifier(FontTitle())
            
            SearchField(
                $viewModel.searchText,
                placeholder: "Postleitzahl"
            ) {
                viewModel.search()
            }
            
            if viewModel.teams.isEmpty {
                if let message = viewModel.message {
                    Text(message)
                        .font(.custom(Font.normal, size: FontSize.text))
                        .foregroundColor(.customBrown)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                }
            }
            if !viewModel.teams.isEmpty {
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
        SelectTeamView(
            session: Session(),
            teamService: TeamMockService(),
            persistenceController: .preview
        )
    }
}
