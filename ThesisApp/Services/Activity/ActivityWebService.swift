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
        get { UserDefaults.standard.string(forKey: "Activities.versionToken") }
        set { UserDefaults.standard.set(newValue, forKey: "Activities.versionToken") }
    }
    
    func setVersionToken(_ versionToken: String?) {
        self.versionToken = versionToken
    }
    
    
    func importActivities() -> AnyPublisher<ListData<ActivityData>, Error> {
        guard let url = URL(string: Http.baseUrl + "/private/activities") else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, Error>(error: HttpError.invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(versionToken) else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, Error>(error: HttpError.invalidData)
            )
        }
        
        return Http.post(url, payload: payload)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw HttpError.serverError
                }
                return output.data
            }
            .decode(type: ListData<ActivityData>.self, decoder: Http.decoder)
            .mapError { error in
                HttpError.invalidData
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<ListData<ActivityData>, Error> {
        guard let url = URL(string: Http.baseUrl + "/private/activities/save") else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, Error>(error: HttpError.invalidUrl)
            )
        }
        
        let data = ListData<ActivityData>(
            activities,
            versionToken: self.versionToken
        )
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<ListData<ActivityData>, Error>(error: HttpError.invalidData)
            )
        }
        
        return Http.post(url, payload: payload)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw HttpError.serverError
                }
                return output.data
            }
            .decode(type: ListData<ActivityData>.self, decoder: Http.decoder)
            .mapError { error in
                HttpError.invalidData
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func syncActivities(from context: NSManagedObjectContext) -> AnyPublisher<ListData<ActivityData>, Error> {
        guard self.versionToken != nil else {
            return self.importActivities()
        }

        let request = Activity.fetchRequest(NSPredicate(format: "version = nil"))
        
        if let activities = try? context.fetch(request), !activities.isEmpty {
            return self.saveActivities(activities.map { ActivityData($0) })
        }
    
        return AnyPublisher(Fail<ListData<ActivityData>, Error>(error: HttpError.invalidData))
    }
}
