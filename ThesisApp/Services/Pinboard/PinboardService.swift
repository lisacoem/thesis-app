//
//  PinboardService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation
import Combine

protocol PinboardService {
    
    func importPostings() -> AnyPublisher<ListData<PostingResponseData>, HttpError>
    
    func createPosting(_ posting: PostingRequestData) -> AnyPublisher<PostingResponseData, HttpError>
    func deletePosting(with id: Int64) -> AnyPublisher<Void, HttpError>
    
    func createComment(_ comment: CommentRequestData) -> AnyPublisher<PostingResponseData, HttpError>
    func deleteComment(with id: Int64) -> AnyPublisher<Void, HttpError>
    
}
