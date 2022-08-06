//
//  TrackPointDto.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 26.07.22.
//

import CoreData
import CoreLocation

public struct TrackPointDto {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
}

extension TrackPointDto: Decodable, Encodable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case latitude, longitude, timeStamp
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        timestamp = try values.decode(Date.self, forKey: .timeStamp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(timestamp, forKey: .timeStamp)
    }
}

extension TrackPointDto {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension TrackPoint {
    
    public convenience init(from dto: TrackPointDto, for activity: Activity, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.activity = activity
        latitude =  dto.latitude
        longitude = dto.longitude
        timeStamp = dto.timestamp
    }
}
