//
//  PostingDetailViewModel.swift
//  ThesisApp
//
//  ViewModel of PostingDetailView
//
//  Created by Lisa Wittmann on 24.08.22.
//

import SwiftUI
import Combine

extension PostingDetailView {
    
    class ViewModel: ObservableObject {
        
        @Published var comment: String
        @Published var disconnected: Bool
        @Published var unlockedAchievements: [Achievement]?
        
        private let posting: Posting
        private let pinboardService: PinboardService
        private let persistenceController: PersistenceController
        
        var cancellables: Set<AnyCancellable>
        
        init(
            posting: Posting,
            pinboardService: PinboardService,
            persistenceContoller: PersistenceController
        ) {
            self.comment = ""
            self.posting = posting
            self.disconnected = false
            
            self.cancellables = Set()
            self.pinboardService = pinboardService
            self.persistenceController = persistenceContoller
        }
        
        var data: CommentRequestData {
            CommentRequestData(
                postingId: posting.id,
                content: comment
            )
        }
        
        /// add a new comment with the entered text to the given posting
        /// add network warning if user is disconneted
        func addComment() {
            pinboardService.createComment(data)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            self.disconnected = false
                        case .failure(let error):
                            self.disconnected = error == .unavailable
                        }
                    },
                    receiveValue: resolve
                )
                .store(in: &cancellables)
        }
        
        /// store updates points in user defaults and save updated posting and unlocked achievements in database
        /// - Parameter response: api response data
        func resolve(_ response: Achieved<PostingResponseData>) {
            UserDefaults.standard.set(response.points, for: .points)
            
            _ = self.persistenceController.save(with: response.data)
            
            if !response.achievements.isEmpty {
                unlockedAchievements = response.achievements.map {
                    persistenceController.save(with: $0)
                }
            }
            
            self.comment = ""
        }
        
        
        /// delete the selected comment and show warning if user is disconneted
        /// - Parameter comment: comment that should be deleted
        func deleteComment(_ comment: Comment) {
            pinboardService.deleteComment(with: comment.id)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            self.disconnected = false
                            self.persistenceController.delete(comment)
                        case .failure(let error):
                            self.disconnected = error == .unavailable
                        }
                    },
                    receiveValue: { _ in }
                )
                .store(in: &cancellables)
        }
    }
}
