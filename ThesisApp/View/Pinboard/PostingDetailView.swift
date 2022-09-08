//
//  PostingDetailView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI
import PopupView

struct PostingDetailView: View {
    
    @ObservedObject var posting: Posting
    @StateObject var viewModel: ViewModel
    @AppStorage var userId: Int
    
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
        self._userId = AppStorage(wrappedValue: 0, .userId)
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
        .networkAlert(isPresented: $viewModel.disconnected)
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            
            Text(posting.headline)
                .modifier(FontTitle())
                .modifier(Header())
            
            VStack(alignment: .leading, spacing: 0) {
                Text("von **\(posting.creator.friendlyName)**")
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
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            ForEach(posting.comments) { comment in
                CommentDetail(comment)
                    .contextMenu {
                        menu(for: comment)
                    }
            }
        }
        .padding(.bottom, Spacing.ultraLarge)
    }
    
    @ViewBuilder
    func menu(for comment: Comment) -> some View {
        if posting.isCreator(userId) || comment.isCreator(userId) {
            ButtonMenu {
                Button(role: .destructive, action: { viewModel.deleteComment(comment) }) {
                    Label("Kommentar löschen", systemImage: "trash")
                }
            }
        } else {
            EmptyView()
        }
    }

}

struct PostingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let pinboardService = PinboardMockService()
        let persistenceController = PersistenceController.preview
        let postings = pinboardService.postings.map {
            Posting(
                with: $0,
                by: persistenceController.save(with: $0.creator),
                in: persistenceController.container.viewContext
            )
        }
        
        PostingDetailView(
            posting: postings.last!,
            pinboardService: pinboardService,
            persistenceController: persistenceController
        )
    }
}
