//
//  NoticeLink.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct NoticeLink: View {
    
    var notice: PinboardEntry
    
    init(_ notice: PinboardEntry) {
        self.notice = notice
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
        HStack {
                VStack(spacing: spacing) {
                    Text(notice.title)
                        .font(.custom(fontBold, size: fontSize))
                        .frame(maxWidth: .infinity, alignment: .leading)
        
                    KeywordList(notice.keywords)
                        .font(.custom(fontBold, size: fontSizeText))
                        
                }
                Image(systemName: "chevron.right")
                    .font(.custom(fontNormal, size: fontSize))
                    
            }
            .foregroundColor(colorBlack)
        }
    }
    
    var destination: some View {
        NoticeDetailView(notice)
    }
    
    let spacing: CGFloat = 5
    let fontSize: CGFloat = 22
}

struct NoticeLink_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let notices: [PinboardEntry] = try! persistenceController.container.viewContext.fetch(PinboardEntry.fetchRequest())
        
        NoticeLink(notices.first!)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
