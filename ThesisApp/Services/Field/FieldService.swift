//
//  FieldService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation
import Combine

protocol FieldService {
    
    func getFields() -> AnyPublisher<[FieldData], HttpError>
    func getDaytime(at field: Field) -> AnyPublisher<Daytime, HttpError>

}
