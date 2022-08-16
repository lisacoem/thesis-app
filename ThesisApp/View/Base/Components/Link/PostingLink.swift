//
//  PostingLink.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct PostingLink: View {
    
    var posting: Posting
    
    init(_ posting: Posting) {
        self.posting = posting
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                
                VStack(spacing: spacing) {
                    
                    Text(posting.headline)
                        .font(.custom(Font.bold, size: IconSize.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
        
                    KeywordList(posting.keywords)
                        .font(.custom(Font.bold, size: FontSize.text))
                        
                }
                
                Image(systemName: "chevron.right")
                    .font(.custom(Font.normal, size: IconSize.medium))
                    
            }.foregroundColor(.customBlack)
        }
    }
    
    var destination: some View {
        PostingDetailView(posting)
            .navigationLink()
    }
    
    let spacing: CGFloat = 5
}

struct PostingLink_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let postings: [Posting] = try! persistenceController.container.viewContext.fetch(Posting.fetchRequest())
        
        PostingLink(postings.first!)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
