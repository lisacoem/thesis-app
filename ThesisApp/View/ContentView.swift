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
        let pinboardService: PinboardService
        let activityService: ActivityService
        let authorizationService: AuthorizationService
        
        var anyCancellable: AnyCancellable?
        
        init(
            session: Session,
            trackingController: TrackingController,
            persistenceController: PersistenceController,
            authorizationService: AuthorizationService,
            activityService: ActivityService,
            pinboardService: PinboardService,
            teamService: TeamService
        ) {
            self.session = session
            self.trackingController = trackingController
            self.persistenceController = persistenceController
            self.authorizationService = authorizationService
            self.activityService = activityService
            self.pinboardService = pinboardService
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
        pinboardService: PinboardService,
        teamService: TeamService
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                session: session,
                trackingController: trackingController,
                persistenceController: persistenceController,
                authorizationService: authorizationService,
                activityService: activityService,
                pinboardService: pinboardService,
                teamService: teamService
            )
        )
        self.hideNavigationBar()
    }

    
    var body: some View {
        NavigationView {
            if viewModel.session.isAuthorized {
                if viewModel.session.teamRequired {
                    selectTeam
                } else {
                    main
                }
            } else {
                authorization
            }
        }
    }
    
    var authorization: some View {
        LoginView(
            session: viewModel.session,
            authorizationService: viewModel.authorizationService,
            persistenceController: viewModel.persistenceController
        ).navigationItem("Login")
    }
    
    var selectTeam: some View {
        SelectTeamView(
            session: viewModel.session,
            teamService: viewModel.teamService,
            persistenceController: viewModel.persistenceController
        ).navigationItem("Select Team")
    }
    
    var main: some View {
        TabView {
            ActivitiesView(
                activityService: viewModel.activityService,
                trackingController: viewModel.trackingController,
                persistenceController: viewModel.persistenceController
            )
            .navigationItem("Activities")
            .tabItem {
                Image(systemName: "bicycle")
            }
            
            PinboardView(
                pinboardService: viewModel.pinboardService,
                persistenceController: viewModel.persistenceController
            )
            .navigationItem("Pinboard")
            .tabItem {
                Image(systemName: "list.bullet")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        ContentView(
            session: .init(),
            trackingController: .init(),
            persistenceController: persistenceController,
            authorizationService: AuthorizationMockService(),
            activityService: ActivityMockService(),
            pinboardService: PinboardMockService(),
            teamService: TeamMockService()
        )
        .environment(
            \.managedObjectContext,
             persistenceController.container.viewContext
        )
    }
}
