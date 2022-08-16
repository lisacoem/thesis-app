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
        Container {
            Text("Aktivität vom \(Formatter.date(activity.date))")
                .modifier(FontTitle())
        
            Map(activity.track.map(\.coordinate), fitLocations: true)
                .padding([.leading, .trailing], -Spacing.medium)
                .frame(maxHeight: .infinity)
            
            ColumnList {
                InfoItem(
                    symbol: activity.movement.symbol,
                    value: "\(Formatter.double(activity.distance)) km"
                )
                InfoItem(
                    symbol: "clock",
                    value: Formatter.time(activity.duration)
                )
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
    }
}
