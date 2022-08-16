//
//  CreatePostingView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import SwiftUI

struct CreatePostingView: View {
    
    @StateObject var viewModel: ViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue:
            ViewModel()
        )
    }
    
    var body: some View {
        Container {
            Text("Neuer Aushang")
                .modifier(FontTitle())
                .padding(.bottom, Spacing.medium)
            
            VStack(spacing: Spacing.large) {
                ForEach(viewModel.fields) { field in
                    InputField(field)
                }
            }
            
            Spacer()
            
            ButtonIcon("Veröffentlichen", icon: "checkmark") {}
        }
    }
}

struct CreatePostingView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostingView()
    }
}
