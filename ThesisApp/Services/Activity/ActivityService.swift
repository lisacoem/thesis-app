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
    
    func importActivities() -> AnyPublisher<PointData<[ActivityData]>, HttpError>
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<PointData<[ActivityData]>, HttpError>
    
    func syncActivities(from context: NSManagedObjectContext) -> AnyPublisher<PointData<[ActivityData]>, HttpError>
    
}
