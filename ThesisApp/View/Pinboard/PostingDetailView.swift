//
//  PostingDetailView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI
import PopupView

struct PostingDetailView: View {
    
    var posting: Posting
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
        .networkAlertModal(isPresented: $viewModel.disconnected)
        .achievementModal($viewModel.unlockedAchievements)
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: .medium) {
            
            Text(posting.headline)
                .modifier(FontTitle())
            
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
        VStack(alignment: .leading, spacing: .extraSmall) {
            ForEach(posting.comments) { comment in
                CommentDetail(comment)
                    .contextMenu {
                        menu(for: comment)
                    }
            }
        }
        .spacing(.bottom, .ultraLarge)
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
                by: persistenceController.createOrUpdate(with: $0.creator),
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
