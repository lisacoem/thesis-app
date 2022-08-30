//
//  PostingData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
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

