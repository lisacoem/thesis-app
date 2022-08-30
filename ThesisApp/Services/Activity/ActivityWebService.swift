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
    
    func importActivities() -> AnyPublisher<ListData<ActivityData>, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/activities") else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(versionToken) else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, HttpError>(error: .invalidData)
            )
        }
        
        return Http.post(url, payload: payload, receive: ListData<ActivityData>.self)
    }
    
    
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<ListData<ActivityData>, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/activities/save") else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, HttpError>(error: .invalidUrl)
            )
        }
        
        let data = ListData<ActivityData>(
            data: activities,
            versionToken: versionToken
        )
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, HttpError>(error: .invalidData)
            )
        }
        
        return Http.post(url, payload: payload, receive: ListData<ActivityData>.self)
    }
    
    
    func syncActivities(from context: NSManagedObjectContext) -> AnyPublisher<ListData<ActivityData>, HttpError> {
        guard versionToken != nil else {
            return self.importActivities()
        }

        let request = Activity.fetchRequest(NSPredicate(format: "version = nil"))
        
        if let activities = try? context.fetch(request), !activities.isEmpty {
            return self.saveActivities(activities.map { ActivityData($0) })
        }
    
        return AnyPublisher(
            Fail<ListData<ActivityData>, HttpError>(error: .invalidData)
        )
    }
}
