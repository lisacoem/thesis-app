//
//  PinboardWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation
import Combine

class PinboardWebService: PinboardService {
    
    private var apiPath: String = "/api/v1/private/pinboard"
    
    private var versionToken: String? {
        UserDefaults.standard.string(for: .pinboardVersionToken)
    }
    
    func importPostings() -> AnyPublisher<PinboardData, ApiError> {
        guard let url = URL(string: apiPath, relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<PinboardData, ApiError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Api.encoder.encode(versionToken) else {
            return AnyPublisher(
                Fail<PinboardData, ApiError>(error: .invalidData)
            )
        }
        
        return Api.post(url, payload: payload, receive: PinboardData.self)
    }
    
    
    func createPosting(_ posting: PostingRequestData) -> AnyPublisher<Achieved<PostingResponseData>, ApiError> {
        guard let url = URL(string: apiPath + "/posting", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<Achieved<PostingResponseData>, ApiError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Api.encoder.encode(posting) else {
            return AnyPublisher(
                Fail<Achieved<PostingResponseData>, ApiError>(error: .invalidData)
            )
        }
        
        return Api.post(url, payload: payload, receive: Achieved<PostingResponseData>.self)
    }
    
    func deletePosting(with id: Int64) -> AnyPublisher<Void, ApiError> {
        guard let url = URL(string: apiPath + "/posting/\(id)", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<Void, ApiError>(error: .invalidUrl)
            )
        }
        return Api.delete(url)
    }
    
    
    func createComment(_ comment: CommentRequestData) -> AnyPublisher<Achieved<PostingResponseData>, ApiError> {
        guard let url = URL(string: apiPath + "/comment", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<Achieved<PostingResponseData>, ApiError>(error: ApiError.invalidUrl)
            )
        }
        
        guard let payload = try? Api.encoder.encode(comment) else {
            return AnyPublisher(
                Fail<Achieved<PostingResponseData>, ApiError>(error: ApiError.invalidData)
            )
        }
        
        return Api.post(url, payload: payload, receive: Achieved<PostingResponseData>.self)
    }
    
    func deleteComment(with id: Int64) -> AnyPublisher<Void, ApiError> {
        guard let url = URL(string: apiPath + "/comment/\(id)", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<Void, ApiError>(error: .invalidUrl)
            )
        }
        return Api.delete(url)
    }
    
    
    
}
