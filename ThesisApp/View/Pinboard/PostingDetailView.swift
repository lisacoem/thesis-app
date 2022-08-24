//
//  PostingDetailView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI
import Combine

extension PostingDetailView {
    
    class ViewModel: ObservableObject {
        @Published var comment: String
        
        private let posting: Posting
        private let pinboardService: PinboardService
        private let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            posting: Posting,
            pinboardService: PinboardService,
            persistenceContoller: PersistenceController
        ) {
            self.comment = ""
            self.posting = posting
            self.anyCancellable = Set()
            self.pinboardService = pinboardService
            self.persistenceController = persistenceContoller
        }
        
        var data: CommentRequestData {
            CommentRequestData(
                postingId: posting.id,
                content: comment
            )
        }
        
        func addComment() {
            print(self.comment)
            pinboardService.createComment(data)
                .sink(
                    receiveCompletion: {_ in},
                    receiveValue: { postingData in
                        self.persistenceController.savePosting(with: postingData)
                        self.comment = ""
                    }
                )
                .store(in: &anyCancellable)
        }
    }
}

struct PostingDetailView: View {
    
    @StateObject var viewModel: ViewModel
    var posting: Posting
    
    init(
        posting: Posting,
        pinboardService: PinboardService,
        persistenceController: PersistenceController
    ) {
        self.posting = posting
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                posting: posting,
                pinboardService: pinboardService,
                persistenceContoller: persistenceController
            )
        )
    }
    
    var body: some View {
        ScrollContainer {
            header
            content
            
            if !posting.comments.isEmpty {
                Text("Kommentare").modifier(FontH3())
                comments
            }
        }
        .sticky {
            ButtonInput(
                $viewModel.comment,
                placeholder: "Kommentar schreiben",
                icon: "plus"
            ) {
                viewModel.addComment()
            }
        }
    }
    
    var header: some View {
        VStack(spacing: Spacing.medium) {
            
            Text(posting.headline)
                .modifier(FontTitle())
            
            VStack(spacing: 0) {
                Text("von **\(posting.userName)**")
                .modifier(FontH4())
            
                if !posting.keywords.isEmpty {
                    KeywordList(posting.keywords)
                        .modifier(FontH3())
                }
            }
        }
    }
    
    var content: some View {
        Text(posting.content)
            .modifier(FontText())
    }
    
    var comments: some View {
        VStack(spacing: Spacing.extraSmall) {
            ForEach(posting.comments) { comment in
                CommentDetail(comment)
            }
        }
        .padding(.bottom, Spacing.ultraLarge)
    }

}

struct PostingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let pinboardService = PinboardMockService()
        let persistenceController = PersistenceController.preview
        let postings = pinboardService.postings.map {
            Posting(with: $0, in: persistenceController.container.viewContext)
        }
        
        PostingDetailView(
            posting: postings.last!,
            pinboardService: pinboardService,
            persistenceController: persistenceController
        )
    }
}
