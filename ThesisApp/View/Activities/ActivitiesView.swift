//
//  ActivitiesView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI

extension ActivitiesView {
    
    class ViewModel: ObservableObject {
        
        @Published var isTrackingActive: Bool
        
        let trackingController: TrackingController
        let persistenceController: PersistenceController
        
        init(
            trackingController: TrackingController,
            persistenceController: PersistenceController
        ) {
            self.persistenceController = persistenceController
            self.trackingController = trackingController
            self.isTrackingActive = false
        }
        
        func startTracking() {
            isTrackingActive = true
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
        trackingController: TrackingController,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                trackingController: trackingController,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        Container {
            Text("Aktivitäten").modifier(FontTitle())
            
            NavigationLink(
                destination: destination,
                isActive: $viewModel.isTrackingActive
            ) {
                ButtonIcon(
                    "Aktivität starten",
                    icon: "plus",
                    action: viewModel.startTracking
                )
            }
            
            HStack {
                ForEach(
                    Array(
                        zip(
                            Movement.allCases.indices,
                            Movement.allCases
                        )
                    ), id: \.1
                ) { index, movement in
                    
                    if (index > 0) {
                        Rectangle()
                            .background(Color.customBlack)
                            .frame(maxHeight: 100)
                            .frame(width: 1.5)
                    }
                    
                    InfoItem(
                        symbol: movement.symbol,
                        value: Formatter.double(totalDistance(movement))
                    )
                }
            }
            .padding([.top, .bottom], Spacing.small)
            
            VStack(spacing: Spacing.medium) {
                ForEach(activities) { activity in
                    ActivityLink(activity)
                }
            }
        }
    }
    
    var destination: some View {
        TrackingView(
            trackingController: viewModel.trackingController,
            persistenceController: viewModel.persistenceController
        ).navigationLink()
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
                trackingController: .init(),
                persistenceController: .preview
            ).environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
