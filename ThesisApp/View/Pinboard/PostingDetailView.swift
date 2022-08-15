//
//  PostingDetailView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct PostingDetailView: View {
    
    var posting: Posting
    
    init(_ posting: Posting) {
        self.posting = posting
    }
    
    var body: some View {
        ScrollContainer {
            VStack(spacing: 10) {
                
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
            
            Text(posting.content)
                .modifier(FontText())
            
            if !posting.comments.isEmpty {
                Text("Kommentare").modifier(FontH3())
                
                VStack(spacing: Spacing.extraSmall) {
                    ForEach(posting.comments) { comment in
                        detail(for: comment)
                    }
                }
            }
        }
        .stickyButton("Kommentar schreiben", icon: "plus", action: {})
    }
    
    @ViewBuilder
    private func detail(for comment: Comment) -> some View {
        VStack {
            Text(comment.content)
                .modifier(FontText())
                .frame(minHeight: 40)
                .padding([.top, .bottom,], 15)
                .padding([.leading, .trailing], 30)
                .background(Color.beige)
                .cornerRadius(35)
            Text(comment.userName)
                .foregroundColor(.orange)
                .padding([.leading, .trailing], 5)
                .font(.custom(Font.bold, size: FontSize.text))
                .frame(maxWidth: .infinity, alignment: comment.userId == posting.userId ? .trailing : .leading)
        }
    }
}

struct PostingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let notices: [Posting] = try! persistenceController.container.viewContext.fetch(Posting.fetchRequest())
        
        PostingDetailView(notices.randomElement()!)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
