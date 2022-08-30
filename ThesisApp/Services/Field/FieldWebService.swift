//
//  FieldWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation
import Combine

class FieldWebService: FieldService {
    
    func getFields() -> AnyPublisher<[FieldData], HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/fields") else {
            return AnyPublisher(
                Fail<[FieldData], HttpError>(error: .invalidUrl)
            )
        }
        
        return Http.get(url, receive: [FieldData].self)
    }
    
    func getDaytime(at field: Field) -> AnyPublisher<Daytime, HttpError> {
        guard let url = URL(string: "\(Http.baseUrl)/private/fields/daytime/\(field.id)") else {
            return AnyPublisher(
                Fail<Daytime, HttpError>(error: .invalidUrl)
            )
        }
        
        return Http.get(url, receive: Daytime.self)
    }
    
}
