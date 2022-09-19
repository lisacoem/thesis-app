//
//  TrackingViewModel.swift
//  ThesisApp
//
//  ViewModel of TrackingView
//
//  Created by Lisa Wittmann on 16.08.22.
//

import Combine
import CoreLocation

extension TrackingView {
    
    class ViewModel: ObservableObject {
        
        @Published private(set) var selectedMovement: Movement?
        @Published private(set) var trackingStart: Date
        
        private let trackingController: TrackingController
        private let persistenceController: PersistenceController
        
        var trackedRoute: [CLLocation] { trackingController.locations }
        var trackedDistance: Double { trackingController.distance }
        var trackingEnabled: Bool { trackingController.locating }
        
        var cancellables: Set<AnyCancellable>
        
        init(
            trackingController: TrackingController,
            persistenceController: PersistenceController
        ) {
            self.trackingController = trackingController
            self.persistenceController = persistenceController
            self.selectedMovement = nil
            self.trackingStart = .init()
            self.cancellables = Set()
            
            self.trackingController
                .objectWillChange
                .sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
        
        /// select movement to start tracking
        /// - Parameter movement: movement for tracking
        func selectMovement(_ movement: Movement) {
            self.selectedMovement = movement
            self.trackingStart = .now
            self.trackingController.startTracking(
                for: movement
            )
        }
        
        /// stop tracking and save result as new activity
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
