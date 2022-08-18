//
//  DataList.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation

class ListData<Data: AnyCodable>: AnyCodable {
    
    var data: [Data]
    var versionToken: String?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case data, versionToken
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        try data = values.decode([Data].self, forKey: .data)
        try versionToken = values.decodeIfPresent(String.self, forKey: .versionToken)
        super.init()
    }
    
    init(_ data: [Data], versionToken: String?) {
        self.data = data
        self.versionToken = versionToken
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encodeIfPresent(versionToken, forKey: .versionToken)
    }
}
