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
        get { movement_! }
        set { movement_ = newValue }
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
    
    var synchronized: Bool {
        self.version != nil
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
    
    fileprivate convenience init(
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
    
    convenience init(
        with data: ActivityData,
        movement: Movement,
        version: String? = nil,
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.version = version
        self.movement = movement
        self.distance = data.distance
        self.date = data.date
        self.duration = data.duration
        self.track = data.track.map {
            TrackPoint(from: $0, for: self, in: context)
        }
    }
    
}

extension PersistenceController {
    
    func createOrUpdate(with data: ActivityData, version: String?) -> Activity {
        let request = Activity.fetchRequest(NSPredicate(
            format: "distance_ == %lf AND date_ == %@",
            data.distance,
            data.date as NSDate
        ))
        
        if let activity = try? container.viewContext.fetch(request).first {
            return update(activity, with: version)
        }
        return create(with: data, version: version)
    }
    
    func update(_ activity: Activity, with version: String?) -> Activity {
        activity.version = version
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        return activity
    }
    
    func create(with data: ActivityData, version: String? = nil) -> Activity {
        let movement = createOrUpdate(with: data.movement)
        let activity = Activity(with: data, movement: movement, version: version, in: container.viewContext)
        do {
            try container.viewContext.save()
            print("saved new activity: \(activity.movement) \(activity.distance) \(activity.date)")
        } catch {
            print(error)
            print("failed on activity: \(activity.movement) \(activity.distance) \(activity.date)")
        }
        return activity
    }
    
    func create(
        movement: Movement,
        distance: Double,
        duration: TimeInterval,
        track: [CLLocation]
    ) -> Activity {
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
        return activity
    }
}
