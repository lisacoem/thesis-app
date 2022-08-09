//
//  ThesisApp.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

@main
struct ThesisApp: App {
    let persistenceController = PersistenceController.shared
    let trackingManager = TrackingManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(trackingManager)
        }
    }
}
