//
//  PostingDetailView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI
import PopupView

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
        .popup(
            isPresented: $viewModel.disconnected,
            type: .floater(
                verticalPadding: Spacing.ultraLarge,
                useSafeAreaInset: true
            ),
            position: .bottom,
            animation: .spring(),
            autohideIn: 10
        ) {
            NetworkAlert()
        }
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
            Posting(
                with: $0,
                by: persistenceController.getUser(with: $0.creator),
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
