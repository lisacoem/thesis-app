//
//  ContentView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI
import Combine

extension ContentView {
    class ViewModel: ObservableObject {

        let session: Session

        let trackingController: TrackingController
        let persistenceController: PersistenceController
        
        let teamService: TeamService
        let activityService: ActivityService
        let authorizationService: AuthorizationService
        
        var anyCancellable: AnyCancellable?
        
        init(
            session: Session,
            trackingController: TrackingController,
            persistenceController: PersistenceController,
            authorizationService: AuthorizationService,
            activityService: ActivityService,
            teamService: TeamService
        ) {
            self.session = session
            self.trackingController = trackingController
            self.persistenceController = persistenceController
            self.authorizationService = authorizationService
            self.activityService = activityService
            self.teamService = teamService

            self.anyCancellable = self.session.objectWillChange
                .sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    
    init(
        session: Session,
        trackingController: TrackingController,
        persistenceController: PersistenceController,
        authorizationService: AuthorizationService,
        activityService: ActivityService,
        teamService: TeamService
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                session: session,
                trackingController: trackingController,
                persistenceController: persistenceController,
                authorizationService: authorizationService,
                activityService: activityService,
                teamService: teamService
            )
        )
    }

    
    var body: some View {
        NavigationView {
            if viewModel.session.isAuthorized {
                if viewModel.session.teamRequired {
                    SelectTeamView(
                        session: viewModel.session,
                        teamService: viewModel.teamService,
                        persistenceController: viewModel.persistenceController
                    )
                } else {
                    ActivitiesView(
                        activityService: viewModel.activityService,
                        trackingController: viewModel.trackingController,
                        persistenceController: viewModel.persistenceController
                    )
                }
            } else {
                AuthorizationView(
                    session: viewModel.session,
                    authorizationService: viewModel.authorizationService,
                    persistenceController: viewModel.persistenceController
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            session: .init(),
            trackingController: .init(),
            persistenceController: .preview,
            authorizationService: AuthorizationMockService(),
            activityService: ActivityWebService(),
            teamService: TeamMockService()
        )
        .environment(
            \.managedObjectContext,
             PersistenceController.preview.container.viewContext
        )
    }
}
