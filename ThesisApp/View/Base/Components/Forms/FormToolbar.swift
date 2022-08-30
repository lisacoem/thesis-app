//
//  FormToolbar.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import SwiftUI

struct FormToolbar: ToolbarContent {
    
    @ObservedObject var formModel: FormModel
    @FocusState var focusField: FieldModel?
    
    init(_ formModel: FormModel, focused: FocusState<FieldModel?>) {
        self.formModel = formModel
        self._focusField = focused
    }
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Button(action: focusPreviousField) {
                Image(systemName: "chevron.up")
            }
            .disabled(focusPreviousDisabled)
            
            Button(action: focusNextField) {
                Image(systemName: "chevron.down")
            }
            .disabled(focusNextDisabled)
            
            Spacer()
            
            Button(action: unfocus) {
                Image(systemName: "checkmark")
            }
        }
    }
    
    func unfocus() {
        focusField = nil
    }

    func focusPreviousField() {
        focusField = formModel.previousField(of: focusField)
    }
    
    var focusPreviousDisabled: Bool {
        formModel.hasPreviousField(focusField) ? false : true
    }
    
    func focusNextField() {
        focusField = formModel.nextField(of: focusField)
    }
    
    var focusNextDisabled: Bool {
        formModel.hasNextField(focusField) ? false : true
    }
    
}

