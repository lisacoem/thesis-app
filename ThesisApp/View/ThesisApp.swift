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
        
        let persistenceController = PersistenceController.shared
        
        WindowGroup {
            ContentView(
                session: Session(),
                trackingController: TrackingController(),
                persistenceController: persistenceController,
                authorizationService: AuthorizationWebService(),
                activityService: ActivityWebService(),
                teamService: TeamWebService()
            )
            .environment(
                \.managedObjectContext,
                 persistenceController.container.viewContext
            )
        }
    }
}
