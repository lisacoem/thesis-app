//
//  ActivitiesView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI
import Combine

extension ActivitiesView {
    
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
        
        func startTracking() {
            isTrackingActive = true
        }
        
        func syncActivities() {
            self.activityService.syncActivities(from: persistenceController.container.viewContext)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { data in
                        SessionStorage.activityVersionToken = data.versionToken
                        for activityData in data.data {
                            self.persistenceController.saveActivity(with: activityData, version: data.versionToken)
                        }
                    }
                )
                .store(in: &anyCancellable)
        }
    }
}

struct ActivitiesView: View {
    
    @FetchRequest(
        entity: Activity.entity(),
        sortDescriptors: [NSSortDescriptor(key: "date_", ascending: false)]
    ) var activities: FetchedResults<Activity>
    
    @StateObject var viewModel: ViewModel
    
    init(
        activityService: ActivityService,
        trackingController: TrackingController,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                activityService: activityService,
                trackingController: trackingController,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        ScrollContainer {
            Text("Aktivitäten").modifier(FontTitle())
            
            ButtonLink("Aktivität starten", icon: "plus") {
                TrackingView(
                    trackingController: viewModel.trackingController,
                    persistenceController: viewModel.persistenceController
                ).navigationLink()
            }
            
            ColumnList {
                InfoItem(
                    symbol: Movement.walking.symbol,
                    value: Formatter.double(totalDistance(.walking))
                )
                InfoItem(
                    symbol: Movement.cycling.symbol,
                    value: Formatter.double(totalDistance(.cycling))
                )
            }
            .padding([.top, .bottom], Spacing.small)
            
            LazyVStack(spacing: 30) {
                ForEach(activities) { activity in
                    ActivityLink(activity)
                }
            }
        }
        .onAppear {
            viewModel.syncActivities()
        }
    }
    
    func totalDistance(_ movement: Movement) -> Double {
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
            ActivitiesView(
                activityService: ActivityMockService(),
                trackingController: .init(),
                persistenceController: .preview
            ).environment(
                \.managedObjectContext,
                 persistenceController.container.viewContext
            )
        }
    }
}
