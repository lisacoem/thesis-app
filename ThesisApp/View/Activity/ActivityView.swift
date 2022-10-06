//
//  ActivityView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI
import Combine

struct ActivityView: View {
    
    @FetchRequest var activities: FetchedResults<Activity>
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
        self._activities = FetchRequest(
            entity: Activity.entity(),
            sortDescriptors: [
                NSSortDescriptor(
                    keyPath: \Activity.date_,
                    ascending: false
                )
            ],
            animation: .easeIn
        )
    }
    
    var body: some View {
        List {
            Section {
                ForEach(activities) { activity in
                    ActivityListItem(activity)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.background)
                }
            }
            header: {
                VStack(spacing: .large) {
                    header
                    startActivity
                    results
                }
                .spacing(.top, .extraLarge)
            }
        }
        .onAppear {
            viewModel.saveActivities()
        }
        .refreshable {
            await viewModel.refresh()
        }
        .modifier(ListStyle())
        .achievementModal($viewModel.unlockedAchievements)
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: .extraSmall) {
            Text("Aktivitäten")
                .modifier(FontTitle())
            Spacer()
            Points()
        }
    }
    
    var startActivity: some View {
        ButtonLink("Aktivität starten", icon: "plus") {
            TrackingView(
                trackingController: viewModel.trackingController,
                persistenceController: viewModel.persistenceController
            )
            .navigationLink()
        }
    }
    
    var results: some View {
        HStack {
            ForEach(Movement.allCases) { movement in
                InfoItem(
                    symbol: movement.values().symbol,
                    value: viewModel.totalDistance(from: activities, for: movement)
                )
                if let last = Movement.allCases.last, movement != last {
                    Rectangle()
                        .fill(Color.customBlack)
                        .frame(width: 1, height: 80)
                }
            }
        }
        .spacing(.bottom, .large)
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        NavigationView {
            ActivityView(
                activityService: ActivityMockService(),
                trackingController: .init(),
                persistenceController: .preview
            )
            .environment(
                \.managedObjectContext,
                 persistenceController.container.viewContext
            )
        }
    }
}
