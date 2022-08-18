//
//  CommentData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

class CommentData: AnyCodable {
    
    var id: Int64
    var content: String
    var creationDate: Date
    var userName: String
    var userId: Int64
    
    init(_ comment: Comment) {
        self.id = comment.id
        self.content = comment.content
        self.creationDate = comment.creationDate
        self.userName = comment.userName
        self.userId = comment.userId
        super.init()
    }
    
    init(
        id: Int64,
        content: String,
        creationDate: Date,
        userName: String,
        userId: Int64
    ) {
        self.id = id
        self.content = content
        self.creationDate = creationDate
        self.userName = userName
        self.userId = userId
        super.init()
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, content, creationDate, userName, userId
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        content = try values.decode(String.self, forKey: .content)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        userName = try values.decode(String.self, forKey: .userName)
        userId = try values.decode(Int64.self, forKey: .userId)
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(userName, forKey: .userName)
        try container.encode(userId, forKey: .userId)
    }
    
}
