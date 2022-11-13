//
//  AchievementWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 13.09.22.
//

import Foundation
import Combine

struct AchievementWebService: AchievementService {
    
    private let apiPath = "/api/v1/private/achievements"
    
    func importAchievements() -> AnyPublisher<[AchievementData], ApiError> {
        guard let url = URL(string: apiPath, relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<[AchievementData], ApiError>(error: .invalidUrl)
            )
        }
        
        return Api.get(url, receive: [AchievementData].self)
    }

}

