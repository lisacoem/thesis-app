//
//  PinboardService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation
import Combine

protocol PinboardService {
    
    var versionToken: String? { get set }
    func setVersionToken(_ versionToken: String?) -> Void
    
    func importPostings() -> AnyPublisher<ListData<PostingResponseData>, Error>
    
    func createPosting(_ posting: PostingRequestData) -> AnyPublisher<PostingResponseData, Error>
    func createComment(
        _ comment: CommentRequestData,
        for posting: Posting
    ) -> AnyPublisher<PostingResponseData, Error>
    
}