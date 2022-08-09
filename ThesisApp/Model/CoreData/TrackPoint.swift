//
//  TrackPoint.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData
import CoreLocation

@objc(TrackPoint)
public class TrackPoint: NSManagedObject {
    
    var timestamp: Date {
        get { timestamp_! }
        set { timestamp_ = newValue }
    }
    
    var activity: Activity {
        get { activity_! }
        set { activity_ = newValue }
    }
    
    convenience init(
        latitude: Double,
        longitude: Double,
        timestamp: Date = .now,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
    
    convenience init(
        coordinate: CLLocationCoordinate2D,
        timestamp: Date = .now,
        in context: NSManagedObjectContext
    ) {
        self.init(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            timestamp: timestamp,
            in: context
        )
    }
}

extension TrackPoint: Comparable {
    
    public static func < (lhs: TrackPoint, rhs: TrackPoint) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
}

extension TrackPoint {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<TrackPoint> {
        let request = NSFetchRequest<TrackPoint>(entityName: "TrackPoint")
        request.sortDescriptors = [NSSortDescriptor(key: "activity_", ascending: true)]
        request.predicate = predicate
        return request
    }
}

extension TrackPoint {
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
