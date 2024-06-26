//
//  InputFieldModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import UIKit

class InputFieldModel: ObservableObject, Identifiable {
    
    @Published var value: String
    
    var label: String
    var required: Bool
    
    var type: FieldType
    var contentType: UITextContentType?
    
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
        type: FieldType = .text,
        contentType: UITextContentType? = nil,
        required: Bool = true,
        validate: ((String) -> Bool)? = nil
    ) {
        self.label = label
        self.value = value
        self.type = type
        self.contentType = contentType
        self.required = required
        self.validate = validate ?? { _ in return true}
    }
    
}

extension InputFieldModel {
    
    enum FieldType: String, CaseIterable {
        case email, text, password, textArea
    }
}

extension InputFieldModel: Equatable, Hashable {
    
    static func == (lhs: InputFieldModel, rhs: InputFieldModel) -> Bool {
        lhs.label == rhs.label && lhs.type == rhs.type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
        hasher.combine(type)
    }
}
