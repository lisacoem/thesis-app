//
//  Dto.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 07.09.22.
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

struct TrackPointData: Codable {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    init(_ trackPoint: TrackPoint) {
        self.latitude = trackPoint.latitude
        self.longitude = trackPoint.longitude
        self.timestamp = trackPoint.timestamp
    }
    
    init(
        latitude: Double,
        longitude: Double,
        timestamp: Date
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}

struct ActivitiesResponseData: Decodable {
    var points: Double
    var activities: [ActivityData]
    var versionToken: String?
}

struct ActivitiesRequestData: Encodable {
    var activities: [ActivityData]
    var versionToken: String?
}

