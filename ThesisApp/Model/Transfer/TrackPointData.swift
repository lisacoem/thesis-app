//
//  TrackPointData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.07.22.
//

import CoreData
import CoreLocation

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
