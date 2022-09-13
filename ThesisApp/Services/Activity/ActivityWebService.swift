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
    
    func importActivities() -> AnyPublisher<ActivitiesResponseData, ApiError> {
        guard let url = URL(string: apiPath, relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<ActivitiesResponseData, ApiError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Api.encoder.encode(versionToken) else {
            return AnyPublisher(
                Fail<ActivitiesResponseData, ApiError>(error: .invalidData)
            )
        }
        
        return Api.post(url, payload: payload, receive: ActivitiesResponseData.self)
    }
    
    
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<ActivitiesResponseData, ApiError> {
        guard let url = URL(string: apiPath + "/save", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<ActivitiesResponseData, ApiError>(error: .invalidUrl)
            )
        }
        
        let data = ActivitiesRequestData(
            activities: activities,
            versionToken: versionToken
        )
        
        guard let payload = try? Api.encoder.encode(data) else {
            return AnyPublisher(
                Fail<ActivitiesResponseData, ApiError>(error: .invalidData)
            )
        }
        
        return Api.post(url, payload: payload, receive: ActivitiesResponseData.self)
    }

}
