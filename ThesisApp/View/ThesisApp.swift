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
        WindowGroup {
            ContentView(
                session: Session(),
                trackingController: TrackingController(),
                persistenceController: PersistenceController.shared,
                authorizationService: WebAuthorizationService()
            )
            .environment(
                \.managedObjectContext,
                 PersistenceController.shared.container.viewContext
            )
        }
    }
}
