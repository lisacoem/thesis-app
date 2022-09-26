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
    
    func importMovements() -> AnyPublisher<[MovementData], ApiError>
    func importActivities() -> AnyPublisher<ActivityListData, ApiError>
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<Achieved<ActivityListData>, ApiError>
    
}
