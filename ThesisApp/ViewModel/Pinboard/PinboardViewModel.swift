//
//  PinboardViewModel.swift
//  ThesisApp
//
//  ViewModel of PinboardView
//
//  Created by Lisa Wittmann on 02.09.22.
//

import Foundation
import Combine

extension PinboardView {
    
    class ViewModel: ObservableObject {
        
        @Published var disconnected: Bool
        @Published var unlockedAchievements: [Achievement]?

        var pinboardService: PinboardService
        var persistenceController: PersistenceController
        
        var cancellables: Set<AnyCancellable>
        
        init(
            pinboardService: PinboardService,
            persistenceController: PersistenceController
        ) {
            self.pinboardService = pinboardService
            self.persistenceController = persistenceController
            self.cancellables = Set()
            self.disconnected = false
            self.loadPostings()
        }
        
        /// Get posings from API and store them in database.
        /// Show network warning if user is disconnted
        func loadPostings() {
            self.pinboardService.importPostings()
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            self.disconnected = false
                        case .failure(let error):
                            self.disconnected = error == .unavailable
                        }
                    },
                    receiveValue: self.resolve
                )
                .store(in: &cancellables)
        }
        
        /// Update postings async to provide pull to refresh in view,
        /// Show network warning if user is disconnted
        func refreshPostings() async {
            do {
                let response = try await pinboardService.importPostings().async()
                self.resolve(response)
            } catch {
                if let error = error as? ApiError, error == .unavailable {
                    self.disconnected = true
                }
            }
        }
        
        /// Store version token of response in UserDefaults and save postings in database
        /// - Parameter response: API response data
        func resolve(_ response: PinboardData) {
            UserDefaults.standard.set(response.versionToken, for: .pinboardVersionToken)
            self.disconnected = false
            for postingData in response.postings {
                _ = self.persistenceController.createOrUpdate(with: postingData)
            }
        }
        
        /// Delete the selected posting.
        /// Show warning if user is disconneted
        /// - Parameter posting: posting that should be deleted
        func deletePosting(_ posting: Posting) {
            self.pinboardService.deletePosting(with: posting.id)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            self.disconnected = false
                            self.persistenceController.delete(posting)
                        case .failure(let error):
                            self.disconnected = error == .unavailable
                        }
                    },
                    receiveValue: {_ in}
                )
                .store(in: &cancellables)
        }
    }
}
