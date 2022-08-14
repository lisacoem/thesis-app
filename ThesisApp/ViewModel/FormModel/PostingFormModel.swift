//
//  PostingFormModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation

class PostingFormModel: FormModel {
    
    @Published var title = FieldModel(
        label: "Titel"
    )
    
    @Published var content = FieldModel(
        label: "Inhalt",
        type: .TextArea
    )
    
    override var fields: [FieldModel] {
        return [title, content]
    }
    
    func submit() {
        
    }
}

