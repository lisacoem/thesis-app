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
        @Published var unlockedAchievements: [Achievement]?
        
        let activityService: ActivityService
        let trackingController: TrackingController
        let persistenceController: PersistenceController
        
        var cancellables: Set<AnyCancellable>
        
        init(
            activityService: ActivityService,
            trackingController: TrackingController,
            persistenceController: PersistenceController
        ) {
            self.activityService = activityService
            self.trackingController = trackingController
            self.persistenceController = persistenceController
            self.isTrackingActive = false
            self.cancellables = Set()
            self.loadMovements()
            self.loadActivities()
        }
        
        /// <#Description#>
        /// - Parameters:
        ///   - activities: <#activities description#>
        ///   - movement: <#movement description#>
        /// - Returns: <#description#>
        func totalDistance(from activities: FetchedResults<Activity>, for movement: Movement) -> String {
            Formatter.double(
                activities
                    .filter({ $0.movement.value == movement.value })
                    .map({ $0.distance })
                    .reduce(0, { x, y in x + y })
            )
        }
        
        func startTracking() {
            isTrackingActive = true
        }
        
        /// <#Description#>
        func loadMovements() {
            self.activityService.importMovements()
                .sink(
                    receiveCompletion: {_ in},
                    receiveValue: resolve(_:)
                )
                .store(in: &cancellables)
        }
        
        /// <#Description#>
        func loadActivities() {
            self.activityService.importActivities()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: resolve
                )
                .store(in: &cancellables)
        }
        
        /// <#Description#>
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
                .store(in: &cancellables)
        }
        
        /// <#Description#>
        func refresh() async {
            do {
                let movementData = try await activityService.importMovements().async()
                resolve(movementData)
                
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
        
        /// <#Description#>
        /// - Parameter response: API response data
        private func resolve(_ response: [MovementData]) {
            for movementData in response {
                _ = persistenceController.createOrUpdate(with: movementData)
            }
        }
        
        /// <#Description#>
        /// - Parameter response: API response data
        private func resolve(_ response: ActivityListData) {
            UserDefaults.standard.set(response.versionToken, for: .activityVersionToken)
            
            for activityData in response.activities {
                _ = self.persistenceController.createOrUpdate(
                    with: activityData,
                    version: response.versionToken
                )
            }
        }
        
        /// <#Description#>
        /// - Parameter response: API response data
        private func resolve(_ response: Achieved<ActivityListData>) {
            UserDefaults.standard.set(response.data.versionToken, for: .activityVersionToken)
            UserDefaults.standard.set(response.points, for: .points)
            
            for activityData in response.data.activities {
                _ = self.persistenceController.createOrUpdate(
                    with: activityData,
                    version: response.data.versionToken
                )
            }
            
            if !response.achievements.isEmpty {
                unlockedAchievements = response.achievements.map {
                    persistenceController.createOrUpdate(with: $0)
                }
            }
        }
    }
}
