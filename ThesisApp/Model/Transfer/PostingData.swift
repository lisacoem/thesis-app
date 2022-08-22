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
    var keywords: [String]
}

struct PostingResponseData: Codable {
    
    var id: Int64
    var headline: String
    var content: String
    var creationDate: Date
    var userName: String
    var userId: Int64
    var keywords: [String]
    var comments: [CommentResponseData]
}

