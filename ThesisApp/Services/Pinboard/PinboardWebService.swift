//
//  PinboardWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation
import Combine

class PinboardWebService: PinboardService {
    
    func importPostings() -> AnyPublisher<ListData<PostingResponseData>, Error> {
        guard let url = URL(string: Http.baseUrl + "/private/pinboard") else {
            return AnyPublisher(
                Fail<ListData<PostingResponseData>, Error>(error: HttpError.invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(SessionStorage.pinboardVersionToken) else {
            return AnyPublisher(
                Fail<ListData<PostingResponseData>, Error>(error: HttpError.invalidData)
            )
        }
        
        return Http.post(url, payload: payload)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw HttpError.serverError
                }
                return output.data
            }
            .decode(type: ListData<PostingResponseData>.self, decoder: Http.decoder)
            .mapError { error in
                HttpError.invalidData
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createPosting(_ posting: PostingRequestData) -> AnyPublisher<PostingResponseData, Error> {
        guard let url = URL(string: Http.baseUrl + "/private/pinboard/save") else {
            return AnyPublisher(
                Fail<PostingResponseData, Error>(error: HttpError.invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(posting) else {
            return AnyPublisher(
                Fail<PostingResponseData, Error>(error: HttpError.invalidData)
            )
        }
        
        return Http.post(url, payload: payload)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw HttpError.serverError
                }
                print(output.data)
                return output.data
            }
            .decode(type: PostingResponseData.self, decoder: Http.decoder)
            .mapError { error in
                HttpError.invalidData
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createComment(_ comment: CommentRequestData, for posting: Posting) -> AnyPublisher<PostingResponseData, Error> {
        guard let url = URL(string: Http.baseUrl + "/private/pinboard/\(posting.id)/comment") else {
            return AnyPublisher(
                Fail<PostingResponseData, Error>(error: HttpError.invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(comment) else {
            return AnyPublisher(
                Fail<PostingResponseData, Error>(error: HttpError.invalidData)
            )
        }
        
        return Http.post(url, payload: payload)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw HttpError.serverError
                }
                return output.data
            }
            .decode(type: PostingResponseData.self, decoder: Http.decoder)
            .mapError { error in
                HttpError.invalidData
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}
