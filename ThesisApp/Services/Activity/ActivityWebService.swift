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
    
    func importActivities() -> AnyPublisher<ListData<ActivityData>, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/activities") else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(SessionStorage.activityVersionToken) else {
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
            versionToken: SessionStorage.activityVersionToken
        )
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, HttpError>(error: .invalidData)
            )
        }
        
        return Http.post(url, payload: payload, receive: ListData<ActivityData>.self)
    }
    
    
    func syncActivities(from context: NSManagedObjectContext) -> AnyPublisher<ListData<ActivityData>, HttpError> {
        guard SessionStorage.activityVersionToken != nil else {
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
