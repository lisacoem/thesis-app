//
//  Dto.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.09.22.
//

import Foundation

struct PostingRequestData: Encodable {
    private(set) var headline: String
    private(set) var content: String
    private(set) var keywords: [Keyword]
}

struct PostingResponseData: Codable {
    private(set) var id: Int64
    private(set) var headline: String
    private(set) var content: String
    private(set) var creationDate: Date
    private(set) var creator: UserData
    private(set) var keywords: [Keyword]
    var comments: [CommentResponseData]
}

struct PinboardData: Codable {
    private(set) var postings: [PostingResponseData]
    private(set) var versionToken: String?
}

struct CommentResponseData: Codable {
    private(set) var id: Int64
    private(set) var content: String
    private(set) var creationDate: Date
    private(set) var creator: UserData
}

struct CommentRequestData: Encodable {
    private(set) var postingId: Int64
    private(set) var content: String
}
