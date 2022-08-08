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
        Page {
            VStack(spacing: 10) {
                
                Text(posting.headline)
                    .modifier(FontTitle())
                
                VStack(spacing: 5) {
                    Text("von **\(posting.creator.friendlyName)**")
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
                
                VStack(spacing: spacingExtraSmall) {
                    ForEach(posting.comments) { comment in
                        detail(for: comment)
                    }
                }
            }
        }
        .stickyButton("Kommentar schreiben", icon: "plus", action: {})
    }
    
    private func isCreator(_ user: User) -> Bool {
        return user == posting.creator
    }
    
    @ViewBuilder
    private func detail(for comment: Comment) -> some View {
        VStack {
            Text(comment.content)
                .modifier(FontText())
                .frame(minHeight: 40)
                .padding([.top, .bottom,], 15)
                .padding([.leading, .trailing], 30)
                .background(colorBeige)
                .cornerRadius(35)
            Text(comment.creator.friendlyName)
                .foregroundColor(colorOrange)
                .padding([.leading, .trailing], 5)
                .font(.custom(fontBold, size: fontSizeText))
                .frame(maxWidth: .infinity, alignment: isCreator(comment.creator) ? .trailing : .leading)
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
