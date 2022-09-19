//
//  AchievementViewModel.swift
//  ThesisApp
//
//  ViewModel of AchievementView
//
//  Created by Lisa Wittmann on 18.09.22.
//

import SwiftUI
import Combine

extension AchievementView {
    
    class ViewModel: ObservableObject {
        
        let teamService: TeamService
        let achievementService: AchievementService
        let persistenceController: PersistenceController
        
        var cancellables: Set<AnyCancellable>
        
        init(
            teamService: TeamService,
            achievementService: AchievementService,
            persistenceController: PersistenceController
        ) {
            self.persistenceController = persistenceController
            self.achievementService = achievementService
            self.teamService = teamService
            self.cancellables = Set()
            self.loadAchievements()
        }
        
        /// get achievements from api and store them in database
        func loadAchievements() {
            self.achievementService.importAchievements()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: resolve
                )
                .store(in: &cancellables)
        }
        
        /// update achievements async to provide pull to refresh in view
        func refresh() async {
            do {
                let response = try await achievementService.importAchievements().async()
                resolve(response)
            } catch {
                print(error)
            }
        }
        
        /// store achievement data from api in database
        /// - Parameter response: api response data
        func resolve(_ response: [AchievementData]) {
            for achievementData in response {
                _ = self.persistenceController.save(with: achievementData)
            }
        }
    }
}
