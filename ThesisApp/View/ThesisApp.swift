//
//  ThesisApp.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI
import MapKit

@main
struct ThesisApp: App {
    var body: some Scene {
        let persistenceController = PersistenceController.develop
        let session = Session.preview
        
        WindowGroup {
            ContentView(
                session: session,
                trackingController: TrackingController(),
                persistenceController: persistenceController,
                authorizationService: AuthorizationWebService(),
                activityService: ActivityWebService(),
                pinboardService: PinboardWebService(),
                teamService: TeamWebService()
            )
            .environment(
                \.managedObjectContext,
                 persistenceController.container.viewContext
            )
        }
    }
}
