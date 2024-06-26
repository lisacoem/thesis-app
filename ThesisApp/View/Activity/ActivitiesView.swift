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
        session: Session,
        activityService: ActivityService,
        trackingController: TrackingController,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                session: session,
                activityService: activityService,
                trackingController: trackingController,
                persistenceController: persistenceController
            )
        )
        self._activities = FetchRequest(
            entity: Activity.entity(),
            sortDescriptors: [
                NSSortDescriptor(key: "date_", ascending: false)
            ],
            animation: .easeIn
        )
    }
    
    var body: some View {
        ScrollContainer {
            header
            startActivity
            results
            activityList
        }
        .onAppear {
            viewModel.syncActivities()
        }
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: Spacing.extraSmall) {
            Text("Aktivitäten")
                .modifier(FontTitle())
            
            Spacer()
            
            Points(viewModel.points)
        }
        .modifier(Header())
    }
    
    var startActivity: some View {
        ButtonLink("Aktivität starten", icon: "plus") {
            TrackingView(
                session: viewModel.session,
                trackingController: viewModel.trackingController,
                persistenceController: viewModel.persistenceController
            )
            .navigationLink()
        }
    }
    
    var results: some View {
        ColumnList {
            InfoItem(
                symbol: Movement.walking.symbol,
                value: viewModel.totalDistance(from: activities, for: .walking)
            )
            InfoItem(
                symbol: Movement.cycling.symbol,
                value: viewModel.totalDistance(from: activities, for: .cycling)
            )
        }
        .padding(.vertical, Spacing.ultraSmall)
    }
    
    var activityList: some View {
        LazyVStack(spacing: 30) {
            ForEach(activities) { activity in
                link(for: activity)
            }
        }
    }
    
    @ViewBuilder
    func link(for activity: Activity) -> some View {
        NavigationLink(destination: destination(for: activity)) {
            ListItem(
                headline:
                    "\(activity.movement.name) " +
                    "\(Formatter.double(activity.distance)) km",
                subline: Formatter.date(activity.date)
            )
        }
    }
    
    @ViewBuilder
    func destination(for activity: Activity) -> some View {
        ActivityDetailView(activity)
            .navigationLink()
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        NavigationView {
            ActivityView(
                session: .preview,
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
