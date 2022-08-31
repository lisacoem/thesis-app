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
    
    func getDaytime() -> AnyPublisher<Daytime, HttpError> {
        guard let url = URL(string: "\(Http.baseUrl)/private/fields/daytime") else {
            return AnyPublisher(
                Fail<Daytime, HttpError>(error: .invalidUrl)
            )
        }
        
        return Http.get(url, receive: Daytime.self)
    }
    
    func createPlant(with seed: Seed, at field: Field) -> AnyPublisher<PointData<FieldData>, HttpError> {
        guard let url = URL(string: "\(Http.baseUrl)/private/fields/\(field.id)/plant/\(seed.id)") else {
            return AnyPublisher(
                Fail<PointData<FieldData>, HttpError>(error: .invalidUrl)
            )
        }
        
        return Http.get(url, receive: PointData<FieldData>.self)
    }
    
}
