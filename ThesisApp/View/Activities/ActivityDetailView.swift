//
//  ActivityDetailView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct ActivityDetailView: View {
    var activity: Activity
    
    init(_ activity: Activity) {
        self.activity = activity
    }
    
    var body: some View {
        Page {
            Text("Aktivität vom \(Formatters.date(activity.date))")
                .modifier(FontTitle())
        
            Map(activity.track.map(\.coordinate), fitLocations: true)
                .padding([.leading, .trailing], -spacingMedium)
                .frame(maxHeight: .infinity)
            
            ColumnList {
                DistanceTracker(activity.movement, distance: activity.distance)
                TimeTracker(Formatters.time(activity.duration))
            }
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let activities: [Activity] = try! persistenceController.container.viewContext.fetch(Activity.fetchRequest())
        
        ActivityDetailView(activities.randomElement()!)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(TrackingManager.shared)
    }
}
