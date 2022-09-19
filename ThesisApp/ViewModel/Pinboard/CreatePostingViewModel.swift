//
//  CreatePostingViewModel.swift
//  ThesisApp
//
//  ViewModel of CreatePostingView
//
//  Created by Lisa Wittmann on 16.08.22.
//

import SwiftUI
import Combine

extension CreatePostingView {
    
    class ViewModel: FormModel {
        
        @Binding var unlockedAchievements: [Achievement]?
        
        @Published private(set) var headline: InputFieldModel
        @Published private(set) var content: InputFieldModel
        @Published private(set) var keywords: Set<Keyword>
        
        @Published var disconnected: Bool
        
        private let pinboardService: PinboardService
        private let persistenceController: PersistenceController
        
        init(
            pinboardService: PinboardService,
            persistenceController: PersistenceController,
            unlockedAchievements: Binding<[Achievement]?>
        ) {
            self._unlockedAchievements = unlockedAchievements
            self.pinboardService = pinboardService
            self.persistenceController = persistenceController
            
            self.headline = .init(label: "Titel")
            self.content = .init(label: "Inhalt", type: .textArea)
            self.keywords = Set()
            self.disconnected = false
        }
        
        override var fields: [InputFieldModel] {
            [headline, content]
        }
        
        private var data: PostingRequestData {
            .init(
                headline: self.headline.value,
                content: self.content.value,
                keywords: Array(self.keywords)
            )
        }
        
        /// save posting by api call and store it in database
        /// add network warning if user is disconnected
        /// - Parameter onComplete: callback function on success
        func save(onComplete: @escaping () -> Void) {
            pinboardService.createPosting(data)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            self.disconnected = false
                        case .failure(let error):
                            self.disconnected = error == .unavailable
                        }
                    },
                    receiveValue: { response in
                        self.resolve(response)
                        onComplete()
                    }
                )
                .store(in: &cancellables)
        }
        
        /// store updated points in user defaults and save new posting and unlocked achievements in databse
        /// - Parameter response: api response data
        func resolve(_ response: Achieved<PostingResponseData>) {
            UserDefaults.standard.set(response.points, for: .points)

            _ = self.persistenceController.save(with: response.data)
            
            if !response.achievements.isEmpty {
                unlockedAchievements = response.achievements.map {
                    persistenceController.save(with: $0)
                }
            }
        }
        
        /// add keyword to selected keywords or remove it if it was already added
        /// - Parameter keyword: keyword to update
        func updateKeywords(with keyword: Keyword) {
            if self.keywords.contains(keyword) {
                self.keywords.remove(keyword)
            } else {
                self.keywords.insert(keyword)
            }
        }
        
    }
}
