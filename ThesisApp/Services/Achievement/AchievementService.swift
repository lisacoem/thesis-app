//
//  AchievementService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 13.09.22.
//

import Foundation
import Combine

protocol AchievementService {
    
    func importAchievements() -> AnyPublisher<[AchievementData], ApiError>

}
