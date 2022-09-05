//
//  AnyPublisher+Async.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 05.09.22.
//  Based on: https://medium.com/geekculture/from-combine-to-async-await-c08bf1d15b77
//

import Foundation
import Combine

extension AnyPublisher {
    
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            
            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        break
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    continuation.resume(with: .success(value))
                }
        }
    }
}
