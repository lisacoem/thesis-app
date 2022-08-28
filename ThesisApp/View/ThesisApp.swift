//
//  ThesisApp.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI
import PartialSheet

@main
struct ThesisApp: App {
    var body: some Scene {
        let persistenceController = PersistenceController.shared
        let session = Session.shared
        
        WindowGroup {
            ContentView(
                session: session,
                trackingController: TrackingController(),
                persistenceController: persistenceController,
                authorizationService: AuthorizationWebService(),
                activityService: ActivityWebService(),
                pinboardService: PinboardWebService(),
                fieldService: FieldMockService(),
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
