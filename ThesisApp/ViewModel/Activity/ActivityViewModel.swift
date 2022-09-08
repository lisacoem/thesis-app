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
            self.loadActivities()
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
        
        func loadActivities() {
            self.activityService.importActivities()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: resolve
                )
                .store(in: &anyCancellable)
        }
        
        func saveActivities() {
            let request = Activity.fetchRequest(NSPredicate(format: "version = nil"))
            
            guard
                let activities = try? persistenceController.container.viewContext.fetch(request),
                !activities.isEmpty
            else {
                return
            }
            
            self.activityService.saveActivities(activities.map { ActivityData($0) })
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: resolve
                )
                .store(in: &anyCancellable)
        }
        
        func refreshActivities() async {
            do {
                let request = Activity.fetchRequest(NSPredicate(format: "version = nil"))
                
                guard
                    let activities = try? persistenceController.container.viewContext.fetch(request),
                    !activities.isEmpty
                else {
                    return
                }
                
                let data = try await activityService.saveActivities(activities.map({ .init($0) })).async()
                resolve(data)
            } catch {
                print(error)
            }
        }
        
        private func resolve(_ data: ActivitiesResponseData) {
            UserDefaults.standard.set(data.versionToken, for: .activityVersionToken)
            UserDefaults.standard.set(data.points, for: .points)
            
            for activityData in data.activities {
                self.persistenceController.save(
                    with: activityData,
                    version: data.versionToken
                )
            }
        }
    }
}
