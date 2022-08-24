//
//  FieldData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation

struct FieldData: Decodable {
    
    var id: Int64
    var name: String
    
    var city: String
    var street: String
    var zipcode: String
}
