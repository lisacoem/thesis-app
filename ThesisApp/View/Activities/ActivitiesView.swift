//
//  ActivitiesView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI

struct ActivitiesView: View {
    
    @FetchRequest(
        entity: Activity.entity(),
        sortDescriptors: [NSSortDescriptor(key: "date_", ascending: false)]
    ) var activities: FetchedResults<Activity>
    
    @State var startActivity: Bool = false
    
    var body: some View {
        Container {
            Text("Aktivitäten").modifier(FontTitle())
            
            NavigationLink(destination: destination, isActive: $startActivity) {
                ButtonIcon("Aktivität starten", icon: "plus", action: { startActivity = true })
            }
            
            ColumnList {
                DistanceTracker(.Walking, distance: totalDistance(.Walking))
                DistanceTracker(.Cycling, distance: totalDistance(.Cycling))
            }
            .padding([.top, .bottom], spacingSmall)
            
            VStack(spacing: spacingMedium) {
                ForEach(activities) { activity in
                    ActivityLink(activity)
                }
            }
        }
    }
    
    private var destination: some View {
        StartActivityView().navigationLink()
    }
    
    private func totalDistance(_ movement: Movement) -> Double {
        return activities
            .filter({ $0.movement == movement })
            .map({ $0.distance })
            .reduce(0, { x, y in x + y })
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        NavigationView {
            ActivitiesView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(TrackingManager.shared)
        }
    }
}
