//
//  TrackingView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI
import CoreMotion
import MapKit
import Combine

struct TrackingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    @EnvironmentObject var trackingManager: TrackingManager
    
    var movement: Movement
    
    init(_ movement: Movement) {
        self.movement = movement
    }
    
    var body: some View {
        Page {
            if trackingManager.locating {
                ColumnList {
                    DistanceTracker(
                        movement,
                        distance: trackingManager.distance
                    )
                    Counter(
                        running: $trackingManager.tracking,
                        startTime: trackingManager.startTime
                    )
                }
                
                Map(
                    trackingManager.locations.map(\.coordinate),
                    trackLocation: true
                ).padding([.leading, .trailing], -spacingMedium)
                   
                
                ButtonIcon(
                    "Aktivität beenden",
                    icon: "checkmark",
                    action: saveActivity
                )
            } else {
                PermissionError(
                    symbol: "location.circle",
                    description: "Um Kilometer sammeln zu können, musst du uns erlauben, auf deinen Standort zuzugreifen."
                )
            }
        }
        .onAppear {
            trackingManager.startTracking(for: movement)
        }
    }
    
    private func saveActivity() {
        trackingManager.saveAsActivity(in: viewContext)
        trackingManager.stopTracking()
        dismiss()
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView(.Cycling)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(TrackingManager.shared)
    }
}
