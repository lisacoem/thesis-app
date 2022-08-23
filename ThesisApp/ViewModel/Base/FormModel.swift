//
//  FormModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Combine

class FormModel: ObservableObject {
    
    @Published var errorMessage: String?
    
    var fields: [FieldModel] {
        return []
    }
    
    var errors: Bool {
        return fields.contains(where: { $0.errors })
    }
    
    var anyCancellable: Set<AnyCancellable>
    
    init() {
        anyCancellable = Set<AnyCancellable>()
        for field in fields {
            field.objectWillChange
                .sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
                .store(in: &anyCancellable)
        }
    }
    
    func nextField(of field: FieldModel?) -> FieldModel? {
        guard let field = field, self.hasNextField(field) else {
            return nil
        }
        return fields[fields.firstIndex(of: field)! + 1]
    }
    
    func previousField(of field: FieldModel?) -> FieldModel? {
        guard let field = field, self.hasPreviousField(field) else {
            return nil
        }
        return fields[fields.firstIndex(of: field)! - 1]
    }
    
    func hasNextField(_ field: FieldModel?) -> Bool {
        guard let field = field, let index = fields.firstIndex(of: field) else {
            return false
        }
        return fields.indices.contains(index + 1)
    }
    
    func hasPreviousField(_ field: FieldModel?) -> Bool {
        guard let field = field, let index = fields.firstIndex(of: field) else {
            return false
        }
        return fields.indices.contains(index - 1)
    }

}
