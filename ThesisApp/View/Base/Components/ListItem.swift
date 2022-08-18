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
            VStack(spacing: 5) {
                
                Text(headline)
                .font(.custom(Font.bold, size: IconSize.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(subline)
                    .modifier(FontText())
            }
            
            Image(systemName: "chevron.right")
                .font(.custom(Font.normal, size: IconSize.medium))
                
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
