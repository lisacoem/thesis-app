//
//  KeywordList.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI
import WrappingHStack

struct KeywordList: View {
    
    var keywords: [Keyword]
    
    init(_ keywords: [Keyword]) {
        self.keywords = keywords
    }
    
    var body: some View {
        WrappingHStack(keywords, id: \.self) { keyword in
            Text("#\(keyword.rawValue)")
                .foregroundColor(.customOrange)
                .padding(.top, 5)
        }
    }
}

struct KeywordList_Previews: PreviewProvider {
    static var previews: some View {
        KeywordList(Keyword.allCases)
            .modifier(FontText())
    }
}
