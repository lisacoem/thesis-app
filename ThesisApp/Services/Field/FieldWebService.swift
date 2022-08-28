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
        return AnyPublisher(
            Fail<[FieldData], HttpError>(error: .invalidUrl)
        )
    }
    
    func getDaytime(at field: Field) -> AnyPublisher<Daytime, HttpError> {
        return AnyPublisher(
            Fail<Daytime, HttpError>(error: .invalidUrl)
        )
    }
    
}
