//
//  ActivityData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 10.08.22.
//

import Foundation

struct ActivityData: Codable {
    
    var movement: Movement
    var distance: Double
    var duration: TimeInterval
    var date: Date
    var track: [TrackPointData]
    
    init(_ activity: Activity) {
        self.movement = activity.movement
        self.distance = activity.distance
        self.duration = activity.duration
        self.date = activity.date
        self.track = activity.track.map { TrackPointData($0) }
    }
    
    init(
        movement: Movement,
        distance: Double,
        duration: Double,
        date: Date,
        track: [TrackPointData]
    ) {
        self.movement = movement
        self.distance = distance
        self.duration = duration
        self.date = date
        self.track = track
    }
}
