//
//  PinboardService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation
import Combine

protocol PinboardService {
    
    func importPostings() -> AnyPublisher<PinboardData, ApiError>
    
    func createPosting(_ posting: PostingRequestData) -> AnyPublisher<PostingResponseData, ApiError>
    func deletePosting(with id: Int64) -> AnyPublisher<Void, ApiError>
    
    func createComment(_ comment: CommentRequestData) -> AnyPublisher<PostingResponseData, ApiError>
    func deleteComment(with id: Int64) -> AnyPublisher<Void, ApiError>
    
}
