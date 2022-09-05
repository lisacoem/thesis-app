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
                NSSortDescriptor(key: "date_", ascending: false)
            ],
            animation: .easeIn
        )
    }
    
    var body: some View {
        List {
            Section {
                ForEach(activities) { activity in
                    link(for: activity)
                       
                }
            }
            header: {
                VStack(spacing: Spacing.large) {
                    header
                    startActivity
                    results
                }
                .padding(.top, Spacing.extraLarge)
            }
        }
        .onAppear {
            viewModel.syncActivities()
        }
        .refreshable {
            await viewModel.refreshActivities()
        }
        .modifier(ContainerLayout())
        .environment(\.defaultMinListRowHeight, 75)
        .listStyle(.plain)
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: Spacing.extraSmall) {
            Text("Aktivitäten")
                .modifier(FontTitle())
            
            Spacer()
            
            Points()
        }
        .modifier(Header())
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
            InfoItem(
                symbol: Movement.walking.symbol,
                value: viewModel.totalDistance(from: activities, for: .walking)
            )
            Rectangle()
                .fill(Color.customBlack)
                .frame(width: 1, height: 80)
            InfoItem(
                symbol: Movement.cycling.symbol,
                value: viewModel.totalDistance(from: activities, for: .cycling)
            )
        }
        .padding(.bottom, Spacing.large)
    }
    
    
    @ViewBuilder
    func link(for activity: Activity) -> some View {
        ListItem(
            headline:
                "\(activity.movement.name) " +
                "\(Formatter.double(activity.distance)) km",
            subline: Formatter.date(activity.date)
        )
        .background(
            NavigationLink(destination: destination(for: activity)) {
                EmptyView()
            }.opacity(0)
        )
        .listRowSeparator(.hidden)
        .listRowBackground(Color.background)
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
