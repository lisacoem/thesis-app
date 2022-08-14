//
//  FieldModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

enum FieldModelType: String, CaseIterable {
    case Text, Password, TextArea
}

class FieldModel: ObservableObject, Identifiable {
    
    @Published var value: String
    
    var label: String
    var placeholder: String
    
    var required: Bool
    var type: FieldModelType
    
    var validate: (String) -> Bool
    
    var errors: Bool {
        if required && value.isEmpty {
            return true
        }
        return !validate(value)
    }
    
    init(
        label: String,
        value: String = "",
        placeholder: String = "",
        type: FieldModelType = .Text,
        required: Bool = true,
        validate: ((String) -> Bool)? = nil
    ) {
        self.label = label
        self.value = value
        self.placeholder = placeholder
        self.type = type
        self.required = required
        self.validate = validate ?? { _ in return true}
    }
}
