//
//  TrackingView+ViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 16.08.22.
//

import Combine
import CoreLocation

extension TrackingView {
    
    class ViewModel: ObservableObject {
        
        @Published private(set) var trackingController: TrackingController
        @Published private(set) var selectedMovement: Movement?
        
        private let persistenceController: PersistenceController
        
        var trackedRoute: [CLLocation] { trackingController.locations }
        var trackedDistance: Double { trackingController.distance }
        var trackingStart: Date { trackingController.startTime }
        var trackingEnabled: Bool { trackingController.locating }
        var isTracking: Bool { trackingController.tracking }
        
        var anyCancallable: AnyCancellable?
        
        init(
            trackingController: TrackingController,
            persistenceController: PersistenceController
        ) {
            self.trackingController = trackingController
            self.persistenceController = persistenceController
            self.selectedMovement = nil
            self.anyCancallable = self.trackingController
                .objectWillChange
                .sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
        }
        
        func selectMovement(_ movement: Movement) {
            self.selectedMovement = movement
            self.trackingController.startTracking(
                for: movement
            )
        }
        
        func stopTracking() {
            self.trackingController.stopTracking()
            self.persistenceController.createActivity(
                movement: self.selectedMovement!,
                distance: self.trackedDistance,
                duration: Date().timeIntervalSince(self.trackingStart),
                track: self.trackedRoute
            )
        }
    }
}
