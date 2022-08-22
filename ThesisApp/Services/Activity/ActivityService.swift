//
//  ActivityService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine
import CoreData

protocol ActivityService {
    
    func importActivities() -> AnyPublisher<ListData<ActivityData>, Error>
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<ListData<ActivityData>, Error>
    
    func syncActivities(from context: NSManagedObjectContext) -> AnyPublisher<ListData<ActivityData>, Error>
    
}
