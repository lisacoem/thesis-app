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
    
    func importActivities() -> AnyPublisher<ActivitiesResponseData, HttpError>
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<ActivitiesResponseData, HttpError>
    
}
