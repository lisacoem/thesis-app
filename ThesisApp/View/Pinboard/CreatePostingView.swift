//
//  CreatePostingView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import SwiftUI
import PopupView
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
                .modifier(Header())
                .padding(.bottom, Spacing.medium)
            
            inputFields
            selectField
            
            Spacer()
            
            ButtonIcon("Veröffentlichen", icon: "checkmark") {
                viewModel.save()
                if viewModel.error == nil {
                    dismiss()
                }
            }
        }
        .toolbar {
            FormToolbar(viewModel, focused: _focusField)
        }
        .networkAlert(isPresented: $viewModel.disconnected)
    }
    
    var inputFields: some View {
        VStack(spacing: Spacing.large) {
            ForEach(viewModel.fields) { field in
                InputField(field, focusField: _focusField)
            }
        }
    }
    
    var selectField: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            
            Text("Stichworte")
                .modifier(FontH5())
            
            WrappingHStack(Keyword.allCases) { keyword in
                Pill(
                    keyword.rawValue,
                    selected: viewModel.keywords.contains(keyword)
                )
                .padding(.bottom, Spacing.small)
                .onTapGesture {
                    viewModel.updateKeywords(with: keyword)
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
