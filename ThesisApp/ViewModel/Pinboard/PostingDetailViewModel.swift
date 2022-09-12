//
//  PostingDetailViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 24.08.22.
//

import SwiftUI
import Combine

extension PostingDetailView {
    
    class ViewModel: ObservableObject {
        
        @Published var comment: String
        @Published var disconnected: Bool
        
        private let posting: Posting
        private let pinboardService: PinboardService
        private let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            posting: Posting,
            pinboardService: PinboardService,
            persistenceContoller: PersistenceController
        ) {
            self.comment = ""
            self.posting = posting
            self.disconnected = false
            
            self.anyCancellable = Set()
            self.pinboardService = pinboardService
            self.persistenceController = persistenceContoller
        }
        
        var data: CommentRequestData {
            CommentRequestData(
                postingId: posting.id,
                content: comment
            )
        }
        
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
                    receiveValue: { postingData in
                        _ = self.persistenceController.save(with: postingData)
                        self.comment = ""
                    }
                )
                .store(in: &anyCancellable)
        }
        
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
                .store(in: &anyCancellable)
        }
    }
}
