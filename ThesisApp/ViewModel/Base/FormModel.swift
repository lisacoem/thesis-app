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

}
