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
    
    var versionToken: String? {
        UserDefaults.standard.string(for: .activityVersionToken)
    }
    
    func importActivities() -> AnyPublisher<ActivitiesResponseData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/activities") else {
            return AnyPublisher(
                Fail<ActivitiesResponseData, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(versionToken) else {
            return AnyPublisher(
                Fail<ActivitiesResponseData, HttpError>(error: .invalidData)
            )
        }
        
        return Http.request(url, method: .post, payload: payload, receive: ActivitiesResponseData.self)
    }
    
    
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<ActivitiesResponseData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/activities/save") else {
            return AnyPublisher(
                Fail<ActivitiesResponseData, HttpError>(error: .invalidUrl)
            )
        }
        
        let data = ActivitiesRequestData(
            activities: activities,
            versionToken: versionToken
        )
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<ActivitiesResponseData, HttpError>(error: .invalidData)
            )
        }
        
        return Http.request(url, method: .post, payload: payload, receive: ActivitiesResponseData.self)
    }

}
