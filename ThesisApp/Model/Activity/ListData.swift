//
//  DataList.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation

struct ListData<Data: Codable>: Codable {
    
    var data: [Data]
    var versionToken: String?
}

struct PointData<Data: Decodable>: Decodable {
    
    var points: Double
    var data: Data
    var versionToken: String?
    
}