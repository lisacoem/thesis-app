//
//  ActivityData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 10.08.22.
//

import Foundation

class ActivityData: AnyCodable {
    
    var movement: Movement
    var distance: Double
    var duration: Double
    var date: Date
    var track: [TrackPointData]
    
    init(_ activity: Activity) {
        self.movement = activity.movement
        self.distance = activity.distance
        self.duration = activity.duration
        self.date = activity.date
        self.track = activity.track.map { TrackPointData($0) }
        super.init()
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, movement, distance, duration, date, track
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        movement = Movement(rawValue: try values.decode(String.self, forKey: .movement))!
        distance = try values.decode(Double.self, forKey: .distance)
        duration = try values.decode(Double.self, forKey: .duration)
        date = try values.decode(Date.self, forKey: .date)
        track = try values.decode([TrackPointData].self, forKey: .track)
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(movement.rawValue, forKey: .movement)
        try container.encode(distance, forKey: .distance)
        try container.encode(duration, forKey: .duration)
        try container.encode(date, forKey: .date)
        try container.encode(track, forKey: .track)
    }
}
