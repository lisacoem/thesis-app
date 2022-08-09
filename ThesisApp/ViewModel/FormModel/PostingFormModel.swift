//
//  PostingFormModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation

class PostingFormModel: FormModel {
    
    @Published var title = FieldModel(
        label: "Titel",
        required: true
    )
    
    @Published var content = FieldModel(
        label: "Inhalt",
        required: true
    )
    
    @Published var errorMessage: String?
    
    var errors: Bool {
        title.errors && content.errors
    }
    
    func submit() {
        
    }
    
    func reset() {
        title.value = ""
        content.value = ""
        errorMessage = nil
    }
}

