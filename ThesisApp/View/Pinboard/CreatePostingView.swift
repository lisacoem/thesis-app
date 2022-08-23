//
//  CreatePostingView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import SwiftUI
import WrappingHStack

struct CreatePostingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ViewModel
    @FocusState var focusField: FieldModel?
    
    init(
        pinboardService: PinboardService,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                pinboardService: pinboardService,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        ScrollContainer {
            Text("Neuer Aushang")
                .modifier(FontTitle())
                .padding(.bottom, Spacing.medium)
            
            VStack(spacing: Spacing.large) {
                ForEach(viewModel.fields) { field in
                    InputField(field, focusField: _focusField)
                }
            }
            
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Stichworte")
                    .font(.custom(Font.bold, size: FontSize.text))
                WrappingHStack(Keyword.allCases) { keyword in
                    Pill(
                        keyword.rawValue,
                        selected: viewModel.keywords.contains(keyword.rawValue)
                    )
                    .padding(.bottom, Spacing.small)
                    .onTapGesture {
                        viewModel.updateKeywords(with: keyword.rawValue)
                    }
                }
            }
            
            Spacer()
            
            ButtonIcon("Veröffentlichen", icon: "checkmark") {
                viewModel.save()
                dismiss()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: { focusField = viewModel.previousField(focusField) }) {
                    Image(systemName: "chevron.up")
                }
                .disabled(!viewModel.hasPreviousField(focusField))
                
                Button(action: { focusField = viewModel.nextField(focusField) }) {
                    Image(systemName: "chevron.down")
                }
                .disabled(!viewModel.hasNextField(focusField))
                
                Spacer()
                Button(action: { focusField =  nil }) {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct CreatePostingView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostingView(
            pinboardService: PinboardMockService(),
            persistenceController: .preview
        )
    }
}
