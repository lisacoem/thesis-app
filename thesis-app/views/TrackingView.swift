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
            ColumnList {
                DistanceTrack(movement, distance: trackingManager.distance)
                
                TimeCounter(
                    $trackingManager.duration,
                    running: $trackingManager.tracking,
                    startTime: trackingManager.startTime
                )
            }
            
            TrackingMap()
            
            ButtonIcon("Aktivität beenden", icon: "checkmark", action: saveActivity)
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
