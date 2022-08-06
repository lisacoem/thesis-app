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
        set { movement_ = newValue.name }
    }
    
    var date: Date {
        get { date_! }
        set { date_ = newValue }
    }
    
    var track: [TrackPoint]? {
        get { (track_ as? Set<TrackPoint>)?.sorted() }
        set { track_ = newValue != nil ? Set(newValue!) as NSSet : nil }
    }
    
    public convenience init(
        movement: Movement,
        distance: Float = 0,
        date: Date,
        duration: TimeInterval? = nil,
        track: [TrackPoint]? = nil,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.movement = movement
        self.distance = distance
        self.date = date
        
        self.duration = duration ?? Date().timeIntervalSince(.now)
    }
    
    convenience init(
        movement: Movement,
        distance: Float = 0,
        date: String,
        duration: TimeInterval? = nil,
        track: [TrackPoint]? = nil,
        in context: NSManagedObjectContext
    ) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        self.init(
            movement: movement,
            distance: distance,
            date: formatter.date(from: date) ?? .now,
            duration: duration, track: track,
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
    
    static func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    static func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.date(from: string)
    }
    
    static func string(from distance: Float) -> String {
        "\(distance.toString()) km"
    }
    
    static func string(from activity: Activity) -> String {
        "\(activity.movement.name) \(string(from: activity.distance))"
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
