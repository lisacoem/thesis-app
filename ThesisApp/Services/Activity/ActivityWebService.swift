//
//  ActivityWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine
import CoreData

class ActivityWebService: ActivityService {
    
    private let apiPath: String = "/api/v1/private/activities"
    
    private var versionToken: String? {
        UserDefaults.standard.string(for: .activityVersionToken)
    }
    
    func importMovements() -> AnyPublisher<[MovementData], ApiError> {
        guard let url = URL(string: apiPath + "/movements", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<[MovementData], ApiError>(error: .invalidUrl)
            )
        }
        return Api.get(url, receive: [MovementData].self)
    }
    
    func importActivities() -> AnyPublisher<ActivityListData, ApiError> {
        guard let url = URL(string: apiPath, relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<ActivityListData, ApiError>(error: .invalidUrl)
            )
        }
        guard let payload = try? Api.encoder.encode(versionToken) else {
            return AnyPublisher(
                Fail<ActivityListData, ApiError>(error: .invalidData)
            )
        }
        return Api.post(url, payload: payload, receive: ActivityListData.self)
    }
    
    
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<Achieved<ActivityListData>, ApiError> {
        guard let url = URL(string: apiPath + "/save", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<Achieved<ActivityListData>, ApiError>(error: .invalidUrl)
            )
        }
        let data = ActivityListData(
            activities: activities,
            versionToken: versionToken
        )
        guard let payload = try? Api.encoder.encode(data) else {
            return AnyPublisher(
                Fail<Achieved<ActivityListData>, ApiError>(error: .invalidData)
            )
        }
        return Api.post(url, payload: payload, receive: Achieved<ActivityListData>.self)
    }

}
