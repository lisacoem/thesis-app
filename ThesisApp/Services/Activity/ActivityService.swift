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
    
    var versionToken: String? { get set }
    
    func setVersionToken(_ versionToken: String?) -> Void
    
    func importActivities() -> AnyPublisher<ListData<ActivityData>, Error>
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<ListData<ActivityData>, Error>
    
    func syncActivities(from context: NSManagedObjectContext) -> AnyPublisher<ListData<ActivityData>, Error>
    
}
