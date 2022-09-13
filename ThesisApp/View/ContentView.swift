//
//  ContentView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI
import PartialSheet
import Combine

struct ContentView: View {

    @AppStorage var isLoggedIn: Bool
    @AppStorage var isTeamRequired: Bool
    
    @ObservedObject var trackingController: TrackingController
    
    private let persistenceController: PersistenceController
    private let authorizationService: AuthorizationService
    private let achievementService: AchievementService
    private let activityService: ActivityService
    private let pinboardService: PinboardService
    private let fieldService: FieldService
    private let teamService: TeamService
    
    init(
        trackingController: TrackingController,
        persistenceController: PersistenceController,
        authorizationService: AuthorizationService,
        achievementService: AchievementService,
        activityService: ActivityService,
        pinboardService: PinboardService,
        fieldService: FieldService,
        teamService: TeamService
    ) {
        self._isLoggedIn = AppStorage(wrappedValue: false, .isLoggedIn)
        self._isTeamRequired = AppStorage(wrappedValue: false, .isTeamRequired)
        
        self.trackingController = trackingController
        self.persistenceController = persistenceController
        
        self.authorizationService = authorizationService
        self.achievementService = achievementService
        self.activityService = activityService
        self.pinboardService = pinboardService
        self.fieldService = fieldService
        self.teamService = teamService
        
        self.resetStyles()
    }

    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                if isTeamRequired {
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
            authorizationService: authorizationService,
            persistenceController: persistenceController
        )
        .navigationItem("Login")
    }
    
    var selectTeam: some View {
        SelectTeamView(teamService: teamService)
            .navigationItem("Select Team")
    }
    
    var main: some View {
        TabView {
            ActivityView(
                activityService: activityService,
                trackingController: trackingController,
                persistenceController: persistenceController
            )
            .navigationItem("Activities")
            .tabItem {
                Image(systemName: "bicycle")
            }
            
            FieldView(
                fieldService: fieldService,
                persistenceController: persistenceController
            )
            .navigationItem("Fields")
            .tabItem {
                Image(systemName: "leaf")
            }
            
            PinboardView(
                pinboardService: pinboardService,
                persistenceController: persistenceController
            )
            .navigationItem("Pinboard")
            .tabItem {
                Image(systemName: "text.bubble")
            }
            
            AchievementView(
                teamService: teamService,
                achievementService: achievementService
            )
            .navigationItem("Achievements")
            .tabItem {
                Image(systemName: "chart.bar.xaxis")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        ContentView(
            trackingController: .init(),
            persistenceController: persistenceController,
            authorizationService: AuthorizationMockService(),
            achievementService: AchievementMockService(),
            activityService: ActivityMockService(),
            pinboardService: PinboardMockService(),
            fieldService: FieldMockService(),
            teamService: TeamMockService()
        )
        .attachPartialSheetToRoot()
        .environment(
            \.managedObjectContext,
             persistenceController.container.viewContext
        )
    }
}
