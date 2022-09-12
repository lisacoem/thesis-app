//
//  PinboardMockService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation
import Combine


extension PinboardMockService: PinboardService {
    
    func importPostings() -> AnyPublisher<PinboardData, ApiError> {
        return Just(PinboardData(
                postings: postings,
                versionToken: versionToken
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func createPosting(_ posting: PostingRequestData) -> AnyPublisher<PostingResponseData, ApiError> {
        return Just(.init(
                id: Int64(self.postings.count + 1),
                headline: posting.headline,
                content: posting.content,
                creationDate: .now,
                creator: .init(id: 0, firstName: "Max", lastName: "Mustermann"),
                keywords: [],
                comments: []
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func deletePosting(with id: Int64) -> AnyPublisher<Void, ApiError> {
        postings.removeAll(where: { $0.id == id })

        return AnyPublisher(
            Empty<Void, ApiError>()
        )
    }
    
    func createComment(_ comment: CommentRequestData) -> AnyPublisher<PostingResponseData, ApiError> {
        guard var storedPosting = postings.filter({ $0.id == comment.postingId }).first else {
            return AnyPublisher(
                Fail<PostingResponseData, ApiError>(error: ApiError.invalidData)
            )
        }
        
        storedPosting.comments.append(CommentResponseData(
            id: 10,
            content: comment.content,
            creationDate: .now,
            creator: .init(id: 0, firstName: "Max", lastName: "Mustermann")
        ))
        
        return Just(storedPosting)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func deleteComment(with id: Int64) -> AnyPublisher<Void, ApiError> {
        guard var posting = postings.filter({ $0.comments.contains(where: { $0.id == id }) }).first else {
            return AnyPublisher(
                Fail<Void, ApiError>(error: ApiError.invalidData)
            )
        }
        
        posting.comments.removeAll(where: { $0.id == id })
        return AnyPublisher(
            Empty<Void, ApiError>()
        )
    }
}

class PinboardMockService {
    
    var versionToken: String? = nil
    
    var postings: [PostingResponseData] = [
        .init(
            id: 0,
            headline: "Mitfahrgelegenheit nach FFM",
            content: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.",
            creationDate: .now,
            creator: .init(id: 1, firstName: "Justus", lastName: "Biegel"),
            keywords: [Keyword.transport],
            comments: []
        ),
        .init(
            id: 1,
            headline: "Joggingpartner gesucht",
            content: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.",
            creationDate: .now,
            creator: .init(id: 2, firstName: "Martina", lastName: "Wunder"),
            keywords: [Keyword.need],
            comments: []
        ),
        .init(
            id: 2,
            headline: "Grillparty im Hof am Samstag",
            content: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.",
            creationDate: .now,
            creator: .init(id: 3, firstName: "Martin", lastName: "Klein"),
            keywords: [Keyword.party, Keyword.food, Keyword.event],
            comments: [
                .init(
                    id: 0,
                    content: "Super Idee, ich freue mich! Soll ich Getränke mitbringen?",
                    creationDate: .now,
                    creator: .init(id: 4, firstName: "Anja", lastName: "Mertens")
                ),
                .init(
                    id: 1,
                    content: "Hi Anja, bring doch deine selbstgemacht Bowle vom letzten Mal wieder mit?",
                    creationDate: .now,
                    creator: .init(id: 3, firstName: "Martin", lastName: "Klein")
                )
            ]
        ),
    ]
}
