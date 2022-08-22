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
        
        @Published private(set) var keywords: Set<String>
        
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
            self.content = .init(label: "Inhalt")
            self.keywords = Set()
        }
        
        func save() {
            let data = PostingRequestData(
                headline: self.headline.value,
                content: self.content.value,
                keywords: Array(self.keywords)
            )
            
            pinboardService.createPosting(data)
                .sink(
                    receiveCompletion: {_ in},
                    receiveValue: { data in
                        print(data.headline)
                        self.persistenceController.savePosting(with: data)
                    }
                ).store(in: &anyCancellable)
        }
        
        func updateKeywords(with keyword: String) {
            if self.keywords.contains(keyword) {
                self.keywords.remove(keyword)
            } else {
                self.keywords.insert(keyword)
            }
        }
        
    }
}
