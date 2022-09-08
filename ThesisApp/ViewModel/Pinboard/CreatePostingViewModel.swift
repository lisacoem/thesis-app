//
//  CreatePostingView+ViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 16.08.22.
//

import Foundation

extension CreatePostingView {
    
    class ViewModel: FormModel {
        
        @Published private(set) var headline: FieldModel
        @Published private(set) var content: FieldModel
        
        @Published private(set) var keywords: Set<Keyword>
        
        @Published var disconnected: Bool
        @Published var error: HttpError?
        
        override var fields: [FieldModel] { [headline, content] }
        
        private let pinboardService: PinboardService
        private let persistenceController: PersistenceController
        
        init(
            pinboardService: PinboardService,
            persistenceController: PersistenceController
        ) {
            self.pinboardService = pinboardService
            self.persistenceController = persistenceController
            
            self.headline = .init(label: "Titel")
            self.content = .init(label: "Inhalt", type: .textArea)
            self.keywords = Set()
            self.disconnected = false
        }
        
        var data: PostingRequestData {
            .init(
                headline: self.headline.value,
                content: self.content.value,
                keywords: Array(self.keywords)
            )
        }
        
        func save() {
            pinboardService.createPosting(data)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            self.error = nil
                            self.disconnected = false
                        case .failure(let error):
                            self.error = error
                            self.disconnected = error == .unavailable
                        }
                    },
                    receiveValue: { data in
                        self.persistenceController.save(with: data)
                    }
                )
                .store(in: &anyCancellable)
        }
        
        func updateKeywords(with keyword: Keyword) {
            if self.keywords.contains(keyword) {
                self.keywords.remove(keyword)
            } else {
                self.keywords.insert(keyword)
            }
        }
        
    }
}
