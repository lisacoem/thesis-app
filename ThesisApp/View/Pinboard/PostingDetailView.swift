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
        
        func addComment() {
            print(self.comment)
            pinboardService.createComment(self.comment, for: posting)
                .sink(
                    receiveCompletion: {_ in},
                    receiveValue: { data in
                        self.persistenceController.savePosting(with: data)
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
            ButtonIcon("Kommentar schreiben", icon: "plus") {
                
            }
        }
    }
    
    var header: some View {
        VStack(spacing: Spacing.extraSmall) {
            
            Text(posting.headline)
                .modifier(FontTitle())
            
            VStack(spacing: 5) {
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
                detail(for: comment)
            }
        }
    }
    
    
    @ViewBuilder
    func detail(for comment: Comment) -> some View {
        VStack {
            
            Text(comment.content)
                .modifier(FontText())
                .frame(minHeight: 40)
                .padding([.top, .bottom,], 15)
                .padding([.leading, .trailing], 30)
                .background(Color.customBeige)
                .cornerRadius(35)
            
            Text(comment.userName)
                .foregroundColor(.customOrange)
                .padding([.leading, .trailing], 5)
                .font(.custom(Font.bold, size: FontSize.text))
                .frame(
                    maxWidth: .infinity,
                    alignment: comment.userId == posting.userId ? .trailing : .leading
                )
        }
    }
}

