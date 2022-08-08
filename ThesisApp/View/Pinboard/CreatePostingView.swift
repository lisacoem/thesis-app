//
//  CreatePostingView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import SwiftUI

struct CreatePostingView: View {
    
    @StateObject var model = PostingFormModel()
    
    var body: some View {
        Page {
            Text("Neuer Aushang")
                .modifier(FontTitle())
                .padding(.bottom, spacingExtraLarge)
            
            VStack(spacing: spacingLarge) {
                TextInput(model.title)
                TextArea(model.content)
            }
            
            Spacer()
            
            ButtonIcon("Veröffentlichen", icon: "checkmark") {
                model.submit()
            }
        }
    }
}

struct CreatePostingView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostingView()
    }
}
