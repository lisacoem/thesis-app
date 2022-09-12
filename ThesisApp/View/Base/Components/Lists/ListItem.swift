//
//  ListItem.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 17.08.22.
//

import SwiftUI

struct ListItem: View {
    
    var headline: String
    var subline: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .ultraSmall) {
                Text(headline)
                    .modifier(FontH1())
                    .multilineTextAlignment(.leading)
                
                Text(subline)
                    .modifier(FontText())
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .modifier(FontIconMedium())
                
        }
        .foregroundColor(.customBlack)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(
            headline: "Lorem Ipsum",
            subline: "Lorem Ipsum"
        )
    }
}
