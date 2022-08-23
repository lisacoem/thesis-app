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
        let session = Session()
        
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
            .onAppear {
                if let userId = SessionStorage.userId {
                    let request = User.fetchRequest(NSPredicate(format: "id == %i", userId))
                    let user = (try? persistenceController.container.viewContext.fetch(request))?.first
                    session.login(user, token: SessionStorage.token)
                }
            }
        }
    }
}
