//
//  CommentData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

struct CommentResponseData: Codable {
    
    var id: Int64
    var content: String
    var creationDate: Date
    var creator: UserData
}

struct CommentRequestData: Encodable {
    
    var postingId: Int64
    var content: String
}
