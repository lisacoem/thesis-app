//
//  CreatePostingView+ViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 16.08.22.
//

import Foundation

extension CreatePostingView {
    
    class ViewModel: FormModel {
        
        @Published private(set) var title = FieldModel(
            label: "Titel"
        )
        
        @Published private(set) var content = FieldModel(
            label: "Inhalt",
            type: .textArea
        )
        
        override var fields: [FieldModel] {
            return [title, content]
        }
        
    }
}
