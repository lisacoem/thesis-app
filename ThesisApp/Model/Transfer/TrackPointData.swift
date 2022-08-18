//
//  TrackPointData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.07.22.
//

import CoreData
import CoreLocation

class TrackPointData: AnyCodable {
    
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    init(_ trackPoint: TrackPoint) {
        self.latitude = trackPoint.latitude
        self.longitude = trackPoint.longitude
        self.timestamp = trackPoint.timestamp
        super.init()
    }
    
    init(
        latitude: Double,
        longitude: Double,
        timestamp: Date
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        super.init()
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case latitude, longitude, timestamp
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

