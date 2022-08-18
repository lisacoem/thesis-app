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
    
    var latitude: Double {
        get { latitude_ }
        set { latitude_ = newValue.rounded(digits: 12) }
    }
    
    var longitude: Double {
        get { longitude_ }
        set { longitude_ = newValue.rounded(digits: 12) }
    }
    
    private(set) var timestamp: Date {
        get { timestamp_! }
        set { timestamp_ = newValue.formatted ?? newValue }
    }
    
    private(set) var activity: Activity {
        get { activity_! }
        set { activity_ = newValue }
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
        request.sortDescriptors = [NSSortDescriptor(
            key: "activity_",
            ascending: true
        )]
        request.predicate = predicate
        return request
    }
}

extension TrackPoint {
    
    convenience init(
        coordinate: CLLocationCoordinate2D,
        timestamp: Date = .now,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.timestamp = timestamp
    }
    
    convenience init(
        from data: TrackPointData,
        for activity: Activity,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.latitude = data.latitude
        self.longitude = data.longitude
        self.timestamp = data.timestamp
        self.activity = activity
    }
}
