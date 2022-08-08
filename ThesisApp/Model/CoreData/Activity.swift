//
//  Activity.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData

@objc(Activity)
public class Activity: NSManagedObject {
    
    var movement: Movement {
        get { Movement(rawValue: movement_!)! }
        set { movement_ = newValue.rawValue }
    }
    
    var date: Date {
        get { date_! }
        set { date_ = newValue }
    }
    
    var track: [TrackPoint] {
        get { (track_ as? Set<TrackPoint>)?.sorted() ?? [] }
        set { track_ = Set(newValue) as NSSet }
    }
    
    public convenience init(
        movement: Movement,
        distance: Double = 0,
        date: Date,
        duration: TimeInterval? = nil,
        track: [TrackPoint] = [],
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.movement = movement
        self.distance = distance
        self.date = date
        self.track = track
        self.duration = duration ?? Date().timeIntervalSince(.now)
    }
    
    convenience init(
        movement: Movement,
        distance: Double = 0,
        date: String,
        duration: TimeInterval? = nil,
        track: [TrackPoint] = [],
        in context: NSManagedObjectContext
    ) {
        self.init(
            movement: movement,
            distance: distance,
            date: Converters.date(string: date) ?? .now,
            duration: duration,
            track: track,
            in: context
        )
    }
}

extension Activity: Comparable {
    
    public static func < (lhs: Activity, rhs: Activity) -> Bool {
        lhs.date < rhs.date
    }
}

extension Activity {
    
    static func fetchRequest(_ predicate: NSPredicate? = nil) -> NSFetchRequest<Activity> {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        request.sortDescriptors = [NSSortDescriptor(key: "date_", ascending: true)]
        request.predicate = predicate
        return request
    }
}
