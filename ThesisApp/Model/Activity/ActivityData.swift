//
//  ActivityData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 07.09.22.
//

import Foundation

struct ActivityData: Codable {
    private(set) var movement: Movement
    private(set) var distance: Double
    private(set) var duration: TimeInterval
    private(set) var date: Date
    private(set) var track: [TrackPointData]
    
    init(_ activity: Activity) {
        self.movement = activity.movement
        self.distance = activity.distance
        self.duration = activity.duration
        self.date = activity.date
        self.track = activity.track.map {
            TrackPointData($0)
        }
    }
    
    init(movement: Movement, distance: Double, duration: TimeInterval, date: Date, track: [TrackPointData]) {
        self.movement = movement
        self.distance = distance
        self.duration = duration
        self.date = date
        self.track = track
    }
}

struct TrackPointData: Codable {
    private(set) var latitude: Double
    private(set) var longitude: Double
    private(set) var timestamp: Date
    
    init(_ trackPoint: TrackPoint) {
        self.latitude = trackPoint.latitude
        self.longitude = trackPoint.longitude
        self.timestamp = trackPoint.timestamp
    }
    
    init(latitude: Double, longitude: Double, timestamp: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}

struct ActivityListData: Codable {
    private(set) var activities: [ActivityData]
    private(set) var versionToken: String?
}

