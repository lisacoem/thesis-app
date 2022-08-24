//
//  CommentDetail.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 24.08.22.
//

import SwiftUI

struct CommentDetail: View {
    
    var comment: Comment
    
    init(_ comment: Comment) {
        self.comment = comment
    }
    
    var body: some View {
        HStack {
             VStack(alignment: .leading, spacing: 5) {
                 Text(comment.userName)
                    .foregroundColor(.customOrange)
                    .font(.custom(Font.bold, size: FontSize.text))
                
                 Text(comment.content)
                    .font(.custom(Font.normal, size: FontSize.text))
                
            }
            .padding(Spacing.small)
            .background(Color.customLightBeige)
            .cornerRadius(20)
            
            Spacer()
        }
    }
}
