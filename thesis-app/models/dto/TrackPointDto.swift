//
//  TrackPointDto.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 26.07.22.
//

import CoreData
import CoreLocation

public struct TrackPointDto: Identifiable {
    public var id: UUID
    
    var latitude: Double
    var longitude: Double
    var timeStamp: Date
}

extension TrackPointDto: Decodable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case latitude, longitude, timeStamp, pace
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        timeStamp = try values.decode(Date.self, forKey: .timeStamp)
        id = UUID()
    }
    
    public init(latitude: Double, longitude: Double, timeStamp: Date) {
        self.id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.timeStamp = timeStamp
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
        timeStamp = dto.timeStamp
    }
}
