//
//  PinboardViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 02.09.22.
//

import Foundation
import Combine

extension PinboardView {
    
    class ViewModel: ObservableObject {
        
        @Published var disconnected: Bool

        var pinboardService: PinboardService
        var persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            pinboardService: PinboardService,
            persistenceController: PersistenceController
        ) {
            self.pinboardService = pinboardService
            self.persistenceController = persistenceController
            self.anyCancellable = Set()
            self.disconnected = false
            self.loadPostings()
        }
        
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
                    receiveValue: { response in
                        UserDefaults.standard.set(response.versionToken, for: .pinboardVersionToken)
                        for postingData in response.postings {
                            _ = self.persistenceController.save(with: postingData)
                        }
                    }
                )
                .store(in: &anyCancellable)
        }
        
        func refreshPostings() async {
            do {
                let response = try await pinboardService.importPostings().async()
                UserDefaults.standard.set(response.versionToken, for: .pinboardVersionToken)
                for postingData in response.postings {
                    _ = self.persistenceController.save(with: postingData)
                }
            } catch {
                if let error = error as? ApiError, error == .unavailable {
                    self.disconnected = true
                }
            }
        }
        
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
                .store(in: &anyCancellable)
        }
    }
}
