//
//  PostingData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

class PostingData: AnyCodable {
    
    var id: Int64?
    var headline: String
    var content: String
    var creationDate: Date
    var userName: String
    var userId: Int64
    var comments: [CommentData]
    
    init(headline: String, content: String, user: User) {
        self.headline = headline
        self.content = content
        self.creationDate = .now
        self.userName = user.friendlyName
        self.userId  = user.id
        self.comments = []
        super.init()
    }
    
    init(_ posting: Posting) {
        self.id = posting.id
        self.headline = posting.headline
        self.content = posting.content
        self.creationDate = posting.creationDate
        self.userId = posting.userId
        self.userName = posting.userName
        self.comments = posting.comments.map { CommentData($0) }
        super.init()
    }
    
    init(
        id: Int64?,
        headline: String,
        content: String,
        creationDate: Date,
        userName: String,
        userId: Int64,
        comments: [CommentData]
    ) {
        self.id = id
        self.headline = headline
        self.content = content
        self.creationDate = creationDate
        self.userName = userName
        self.userId = userId
        self.comments = comments
        super.init()
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, headline, content, creationDate, userName, userId, comments
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        headline = try values.decode(String.self, forKey: .headline)
        content = try values.decode(String.self, forKey: .content)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        userName = try values.decode(String.self, forKey: .userName)
        userId = try values.decode(Int64.self, forKey: .userId)
        comments = try values.decode([CommentData].self, forKey: .comments)
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(headline, forKey: .headline)
        try container.encode(content, forKey: .content)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(userId, forKey: .userId)
        try container.encode(comments, forKey: .comments)
    }
}
