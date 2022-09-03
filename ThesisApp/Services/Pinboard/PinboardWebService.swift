//
//  PinboardWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation
import Combine

class PinboardWebService: PinboardService {
    
    var versionToken: String? {
        UserDefaults.standard.string(for: .pinboardVersionToken)
    }
    
    func importPostings() -> AnyPublisher<ListData<PostingResponseData>, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/pinboard") else {
            return AnyPublisher(
                Fail<ListData<PostingResponseData>, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(versionToken) else {
            return AnyPublisher(
                Fail<ListData<PostingResponseData>, HttpError>(error: .invalidData)
            )
        }
        
        return Http.request(url, method: .post, payload: payload, receive: ListData<PostingResponseData>.self)
    }
    
    
    func createPosting(_ posting: PostingRequestData) -> AnyPublisher<PostingResponseData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/pinboard/posting") else {
            return AnyPublisher(
                Fail<PostingResponseData, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(posting) else {
            return AnyPublisher(
                Fail<PostingResponseData, HttpError>(error: .invalidData)
            )
        }
        
        return Http.request(url, method: .post, payload: payload, receive: PostingResponseData.self)
    }
    
    func deletePosting(with id: Int64) -> AnyPublisher<Void, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/pinboard/posting/\(id)") else {
            return AnyPublisher(
                Fail<Void, HttpError>(error: .invalidUrl)
            )
        }
        return Http.deleteRequest(url)
    }
    
    
    func createComment(_ comment: CommentRequestData) -> AnyPublisher<PostingResponseData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/pinboard/comment") else {
            return AnyPublisher(
                Fail<PostingResponseData, HttpError>(error: HttpError.invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(comment) else {
            return AnyPublisher(
                Fail<PostingResponseData, HttpError>(error: HttpError.invalidData)
            )
        }
        
        return Http.request(url, method: .post, payload: payload, receive: PostingResponseData.self)
    }
    
    func deleteComment(with id: Int64) -> AnyPublisher<Void, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/pinboard/comment/\(id)") else {
            return AnyPublisher(
                Fail<Void, HttpError>(error: .invalidUrl)
            )
        }
        return Http.deleteRequest(url)
    }
    
    
    
}
