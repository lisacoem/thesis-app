//
//  ThesisApp.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI
import PartialSheet

@main
struct ThesisApp: App {

    var body: some Scene {
        let persistenceController = PersistenceController.shared
        
        WindowGroup {
            ContentView(
                trackingController: TrackingController(),
                persistenceController: persistenceController,
                authorizationService: AuthorizationWebService(),
                achievementService: AchievementMockService(), //MARK: replace
                activityService: ActivityWebService(),
                pinboardService: PinboardWebService(),
                fieldService: FieldWebService(),
                teamService: TeamWebService()
            )
            .attachPartialSheetToRoot()
            .environment(
                \.managedObjectContext,
                 persistenceController.container.viewContext
            )
        }
    }
}
