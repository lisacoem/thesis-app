//
//  CommentDetail.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 24.08.22.
//

import SwiftUI

struct CommentDetail: View {
    
    @ObservedObject var comment: Comment
    
    init(_ comment: Comment) {
        self.comment = comment
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .ultraSmall) {
             Text(comment.creator.friendlyName)
                .foregroundColor(.customOrange)
                .modifier(FontH5())
            
             Text(comment.content)
                .modifier(FontText())
            
        }
        .spacing(.all, .small)
        .background(Color.customLightBeige)
        .cornerRadius(20)
    }
}
