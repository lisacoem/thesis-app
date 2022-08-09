//
//  ContentView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        let transparentAppearence = UINavigationBarAppearance()
        transparentAppearence.configureWithTransparentBackground()
        
        let appearance = UINavigationBar.appearance()
        appearance.standardAppearance = transparentAppearence
        appearance.scrollEdgeAppearance = transparentAppearence
        appearance.compactAppearance = transparentAppearence
    }

    
    var body: some View {
        NavigationView {
            //ActivitiesView()
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(TrackingManager.shared)
    }
}
