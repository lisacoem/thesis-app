//
//  AchievementMockService.swift
//  ThesisApp
//
//  Mock Service Implementation for Preview
//
//  Created by Lisa Wittmann on 13.09.22.
//

import Foundation
import Combine

struct AchievementMockService: AchievementService {
    
    let achievements: [AchievementData] = [
        .init(
            id: 0,
            title: "Halbmarathon",
            content: "Lege 21.0975 Kilometer zurück",
            goal: 21.0975,
            unlocked: true
        ),
        .init(
            id: 1,
            title: "Marathon",
            content: "Lege 42.195 Kilometer zurück",
            goal: 42.195,
            unlocked: false),
        .init(
            id: 2,
            title: "Grüner Daumen",
            content: "Ernte 5 Pflanzen",
            goal: 5,
            unlocked: false
        ),
        .init(
            id: 3,
            title: "Schriftsteller",
            content: "Verfasse 5 Beiträge",
            goal: 5,
            unlocked: true
        ),
        .init(
            id: 4,
            title: "Senf-Dazu-Geber",
            content: "Verfasse 10 Kommentare",
            image: "/images/achievements/senf-dazu-geber.png",
            goal: 10,
            unlocked: false
        )
    ]
    
    func importAchievements() -> AnyPublisher<[AchievementData], ApiError> {
        return Just(achievements)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
}
