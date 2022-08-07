//
//  FieldModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

class FieldModel: ObservableObject {
    
    @Published var value: String
    
    var label: String
    var placeholder: String
    
    var secure: Bool
    var required: Bool
    
    var validate: (String) -> Bool
    
    var errors: Bool {
        if required && value.isEmpty {
            return true
        }
        return validate(value)
    }
    
    init(
        label: String,
        value: String = "",
        placeholder: String = "",
        secure: Bool = false,
        required: Bool = true,
        validate: ((String) -> Bool)? = nil
    ) {
        self.label = label
        self.value = value
        self.placeholder = placeholder
        self.secure = secure
        self.required = required
        self.validate = validate ?? { _ in return true}
    }
}
