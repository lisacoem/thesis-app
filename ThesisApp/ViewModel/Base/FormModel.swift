//
//  FormModel.swift
//  ThesisApp
//
//  Parent class for ViewModels containing Forms
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Combine

class FormModel: ObservableObject {
    
    @Published var errorMessage: String?
    
    // should be implemented properly by child class
    var fields: [InputFieldModel] {
        return []
    }
    
    var errors: Bool {
        return fields.contains(where: { $0.errors })
    }
    
    var cancellables: Set<AnyCancellable>
    
    init() {
        cancellables = Set<AnyCancellable>()
        for field in fields {
            field.objectWillChange
                .sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
    
    func nextField(of field: InputFieldModel?) -> InputFieldModel? {
        guard let field = field, self.hasNextField(field) else {
            return nil
        }
        return fields[fields.firstIndex(of: field)! + 1]
    }
    
    func previousField(of field: InputFieldModel?) -> InputFieldModel? {
        guard let field = field, self.hasPreviousField(field) else {
            return nil
        }
        return fields[fields.firstIndex(of: field)! - 1]
    }
    
    func hasNextField(_ field: InputFieldModel?) -> Bool {
        guard let field = field, let index = fields.firstIndex(of: field) else {
            return false
        }
        return fields.indices.contains(index + 1)
    }
    
    func hasPreviousField(_ field: InputFieldModel?) -> Bool {
        guard let field = field, let index = fields.firstIndex(of: field) else {
            return false
        }
        return fields.indices.contains(index - 1)
    }

}
