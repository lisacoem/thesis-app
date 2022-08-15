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
        track: [TrackPoint] = [],
        in context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.date = .now
        self.movement = movement
        self.distance = distance
        self.track = track
        self.duration = duration
    }
    
    convenience init(with data: ActivityData, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.movement = data.movement
        self.distance = data.distance
        self.date = data.date
        self.duration = TimeInterval(data.duration)
        self.track = data.track.map {
            TrackPoint(from: $0, for: self, in: context)
        }
    }
}

extension PersistenceController {
    
    func saveActivity(with data: ActivityData) {
        let request = Activity.fetchRequest(NSPredicate(
            format: "movement_ = %@ and date_ = %@ and distance = %f",
            data.movement.rawValue,
            data.date as CVarArg,
            data.distance
        ))
        if (try? container.viewContext.fetch(request).first) != nil {
            return
        }
        
        let activity = Activity(with: data, in: container.viewContext)
        print("saved new activity: \(activity.movement) \(activity.distance)")
        try? container.viewContext.save()
    }
}
