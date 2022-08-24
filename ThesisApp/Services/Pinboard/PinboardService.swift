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
    
    func createComment(_ comment: CommentRequestData) -> AnyPublisher<PostingResponseData, HttpError>
    
}
