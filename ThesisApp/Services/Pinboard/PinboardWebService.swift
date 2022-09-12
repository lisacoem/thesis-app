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
        guard let url = URL(string: apiPath, relativeTo: API.baseUrl) else {
            return AnyPublisher(
                Fail<PinboardData, ApiError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? API.encoder.encode(versionToken) else {
            return AnyPublisher(
                Fail<PinboardData, ApiError>(error: .invalidData)
            )
        }
        
        return API.post(url, payload: payload, receive: PinboardData.self)
    }
    
    
    func createPosting(_ posting: PostingRequestData) -> AnyPublisher<PostingResponseData, ApiError> {
        guard let url = URL(string: apiPath + "/posting", relativeTo: API.baseUrl) else {
            return AnyPublisher(
                Fail<PostingResponseData, ApiError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? API.encoder.encode(posting) else {
            return AnyPublisher(
                Fail<PostingResponseData, ApiError>(error: .invalidData)
            )
        }
        
        return API.post(url, payload: payload, receive: PostingResponseData.self)
    }
    
    func deletePosting(with id: Int64) -> AnyPublisher<Void, ApiError> {
        guard let url = URL(string: apiPath + "/posting/\(id)", relativeTo: API.baseUrl) else {
            return AnyPublisher(
                Fail<Void, ApiError>(error: .invalidUrl)
            )
        }
        return API.delete(url)
    }
    
    
    func createComment(_ comment: CommentRequestData) -> AnyPublisher<PostingResponseData, ApiError> {
        guard let url = URL(string: apiPath + "/comment", relativeTo: API.baseUrl) else {
            return AnyPublisher(
                Fail<PostingResponseData, ApiError>(error: ApiError.invalidUrl)
            )
        }
        
        guard let payload = try? API.encoder.encode(comment) else {
            return AnyPublisher(
                Fail<PostingResponseData, ApiError>(error: ApiError.invalidData)
            )
        }
        
        return API.post(url, payload: payload, receive: PostingResponseData.self)
    }
    
    func deleteComment(with id: Int64) -> AnyPublisher<Void, ApiError> {
        guard let url = URL(string: apiPath + "/comment/\(id)", relativeTo: API.baseUrl) else {
            return AnyPublisher(
                Fail<Void, ApiError>(error: .invalidUrl)
            )
        }
        return API.delete(url)
    }
    
    
    
}
