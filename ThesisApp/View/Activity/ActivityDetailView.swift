//
//  ActivityDetailView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct ActivityDetailView: View {
    
    var activity: Activity
    
    init(_ activity: Activity) {
        self.activity = activity
    }
    
    var body: some View {
        Container {
            Text("Aktivität vom \(Formatter.date(activity.date))")
                .modifier(FontTitle())
        
            Map(activity.track.map(\.coordinate), fitLocations: true)
                .spacing(.horizontal, .medium, negated: true)
                .frame(maxHeight: .infinity)
            
            ColumnList {
                InfoItem(
                    symbol: activity.movement.values().symbol,
                    value: "\(Formatter.double(activity.distance)) km"
                )
                InfoItem(
                    symbol: "clock",
                    value: Formatter.time(activity.duration)
                )
            }
        }
    }
}
