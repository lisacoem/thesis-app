//
//  NoticeDetailView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI
import EventKit

struct NoticeDetailView: View {
    
    @State var eventStore = EKEventStore()
    var notice: PinboardEntry
    
    init(_ notice: PinboardEntry) {
        self.notice = notice
    }
    
    var body: some View {
        Page {
            VStack(spacing: 10) {
                
                Text(notice.title)
                    .modifier(FontTitle())
                
                VStack(spacing: 5) {
                    Text("von **\(notice.creator.friendlyName)**")
                    .modifier(FontH4())
                
                    if !notice.keywords.isEmpty {
                        KeywordList(notice.keywords)
                            .modifier(FontH3())
                    }
                }
            }
            
            Text(notice.content)
                .modifier(FontText())
            
            if !notice.comments.isEmpty {
                Text("Kommentare").modifier(FontH3())
                
                VStack(spacing: spacingExtraSmall) {
                    ForEach(notice.comments) { comment in
                        detail(for: comment)
                    }
                }
            }
        }
        .stickyButton("Kommentar schreiben", icon: "plus", action: {} )
    }
    
    private func isCreator(_ user: User) -> Bool {
        return user == notice.creator
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
            Text(comment.user.friendlyName)
                .foregroundColor(colorOrange)
                .padding([.leading, .trailing], 5)
                .font(.custom(fontBold, size: fontSizeText))
                .frame(maxWidth: .infinity, alignment: isCreator(comment.user) ? .trailing : .leading)
        }
    }
}

struct NoticeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let notices: [PinboardEntry] = try! persistenceController.container.viewContext.fetch(PinboardEntry.fetchRequest())
        
        NoticeDetailView(notices.randomElement()!)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
