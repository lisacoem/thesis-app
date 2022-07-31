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
            Text("Aktivität vom \(Activity.string(from: activity.date))")
            .modifier(FontTitle())
        
            ActivityMap(activity)
            
            ColumnList {
                DistanceTrack(activity.movement, distance: activity.distance)
                TimeTrack(activity.duration.format(using: [.hour, .minute]))
            }
        }
    }
    
    @ViewBuilder
    private func info(icon: String, value: String) -> some View {
        
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
