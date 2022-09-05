//
//  ActivitiesViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import SwiftUI
import Combine

extension ActivityView {
    
    class ViewModel: ObservableObject {
        
        @Published var isTrackingActive: Bool
        
        let activityService: ActivityService
        let trackingController: TrackingController
        let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            activityService: ActivityService,
            trackingController: TrackingController,
            persistenceController: PersistenceController
        ) {
            self.activityService = activityService
            self.trackingController = trackingController
            self.persistenceController = persistenceController
            self.isTrackingActive = false
            self.anyCancellable = Set()
        }
        
        func totalDistance(
            from activities: FetchedResults<Activity>,
            for movement: Movement
        ) -> String {
            Formatter.double(
                activities
                    .filter({ $0.movement == movement })
                    .map({ $0.distance })
                    .reduce(0, { x, y in x + y })
            )
        }
        
        func startTracking() {
            isTrackingActive = true
        }
        
        func syncActivities() {
            self.activityService.syncActivities(from: persistenceController.container.viewContext)
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { data in
                        UserDefaults.standard.set(data.versionToken, for: .activityVersionToken)
                        UserDefaults.standard.set(data.points, for: .points)
                        
                        for activityData in data.data {
                            self.persistenceController.saveActivity(
                                with: activityData,
                                version: data.versionToken
                            )
                        }
                    }
                )
                .store(in: &anyCancellable)
        }
        
        func refreshActivities() async {
            do {
                let data = try await activityService.syncActivities(
                    from: persistenceController.container.viewContext
                ).async()
                
                UserDefaults.standard.set(data.versionToken, for: .activityVersionToken)
                UserDefaults.standard.set(data.points, for: .points)
                
                for activityData in data.data {
                    self.persistenceController.saveActivity(
                        with: activityData,
                        version: data.versionToken
                    )
                }
            } catch {
                print(error)
            }
        }
    }
}
