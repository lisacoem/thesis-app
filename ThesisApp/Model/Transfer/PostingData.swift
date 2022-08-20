//
//  PostingData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

struct PostingRequestData: Encodable {
    
    var headline: String
    var content: String
}

struct PostingResponseData: Codable {
    
    var id: Int64
    var headline: String
    var content: String
    var creationDate: Date
    var userName: String
    var userId: Int64
    var comments: [CommentResponseData]
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, headline, content, creationDate, userName, userId, comments
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        try id = values.decode(Int64.self, forKey: .id)
        try headline = values.decode(String.self, forKey: .headline)
        try content = values.decode(String.self, forKey: .content)
        try creationDate = values.decode(Date.self, forKey: .creationDate)
        try userName = values.decode(String.self, forKey: .userName)
        try userId = values.decode(Int64.self, forKey: .userId)
        try comments = values.decode([CommentResponseData].self, forKey: .comments)
    }
    
    init(
        id: Int64,
        headline: String,
        content: String,
        creationDate: Date,
        userName: String,
        userId: Int64,
        comments: [CommentResponseData]
    ) {
        self.id = id
        self.headline = headline
        self.content = content
        self.creationDate = creationDate
        self.userName = userName
        self.userId = userId
        self.comments = comments
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(headline, forKey: .headline)
        try container.encode(content, forKey: .content)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(userName, forKey: .userName)
        try container.encode(userId, forKey: .userId)
        try container.encode(comments, forKey: .comments)
    }
}

