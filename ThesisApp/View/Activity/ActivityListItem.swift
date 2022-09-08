//
//  ActivityListItem.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 05.09.22.
//

import SwiftUI

struct ActivityListItem: View {
    
    @ObservedObject var activity: Activity

    init(_ activity: Activity) {
        self.activity = activity
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.ultraSmall) {
                HStack {
                    Text("\(activity.movement.name) " +
                         "\(Formatter.double(activity.distance)) km")
                        .modifier(FontH1())
                        .multilineTextAlignment(.leading)
                    
                    if !activity.synchronized {
                        Image(systemName: "icloud.slash")
                            .modifier(FontH3())
                    }
                }
            
                Text(Formatter.date(activity.date))
                    .modifier(FontText())
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .modifier(FontIconMedium())
                
        }
        .foregroundColor(.customBlack)
        .opacity(activity.synchronized ? 1 : 0.5)
        .background(
            NavigationLink(
                destination: destination(for: activity),
                label: { EmptyView() }
            )
            .opacity(0)
        )
    }
    
    @ViewBuilder
    func destination(for activity: Activity) -> some View {
        ActivityDetailView(activity)
            .navigationLink()
    }
    
}

