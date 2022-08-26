//
//  Activity.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 12.07.22.
//

import CoreData
import CoreLocation

@objc(Activity)
public class Activity: NSManagedObject {
    
    fileprivate(set) var movement: Movement {
        get { Movement(rawValue: movement_!)! }
        set { movement_ = newValue.rawValue }
    }
    
    fileprivate(set) var date: Date {
        get { date_! }
        set { date_ = newValue.formatted ?? date }
    }
    
    fileprivate(set) var distance: Double {
        get { distance_ }
        set { distance_ = newValue.rounded(digits: 2) }
    }
    
    fileprivate(set) var duration: TimeInterval {
        get { duration_ }
        set { duration_ = newValue.rounded(digits: 14)}
    }
    
    fileprivate(set) var track: [TrackPoint] {
        get { (track_ as? Set<TrackPoint>)?.sorted() ?? [] }
        set { track_ = Set(newValue) as NSSet }
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

extension Activity {
    
    convenience init(
        movement: Movement,
        distance: Double,
        duration: TimeInterval,
        track: [CLLocation] = [],
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.date = .now
        self.movement = movement
        self.distance = distance
        self.duration = duration
        self.track = track.map {
            TrackPoint(
                coordinate: $0.coordinate,
                timestamp: $0.timestamp,
                for: self,
                in: context
            )
        }
    }
    
    convenience init(with data: ActivityData, version: String? = nil, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.version = version
        self.movement = data.movement
        self.distance = data.distance
        self.date = data.date
        self.duration = data.duration
        self.track = data.track.map {
            TrackPoint(from: $0, for: self, in: context)
        }
    }
    
}

extension PersistenceController {
    
    func saveActivity(with data: ActivityData, version: String?) {
        let request = Activity.fetchRequest(NSPredicate(
            format: "movement_ == %@ AND distance_ == %lf AND date_ == %@",
            data.movement.rawValue,
            data.distance,
            data.date as NSDate
        ))
        
        if let activity = try? container.viewContext.fetch(request).first {
            print("found existing activity: \(activity.movement) \(activity.distance) \(activity.date)")
            activity.version = version
            try? container.viewContext.save()
            return
        }
        
        let activity = Activity(with: data, in: container.viewContext)
        do {
            try container.viewContext.save()
            print("saved new activity: \(activity.movement) \(activity.distance) \(activity.date)")
        } catch {
            print(error)
            print("failed on activity: \(activity.movement) \(activity.distance) \(activity.date)")
        }
    }
    
    func createActivity(
        movement: Movement,
        distance: Double,
        duration: TimeInterval,
        track: [CLLocation]
    ) {
        let activity = Activity(
            movement: movement,
            distance: distance,
            duration: duration,
            track: track,
            in: container.viewContext
        )
        
        do {
            try container.viewContext.save()
            print("saved new activity: \(activity.movement) \(activity.distance) \(activity.date)")
        } catch {
            print(error)
            print("failed on activity: \(activity.movement) \(activity.distance) \(activity.date)")
        }
    }
}
