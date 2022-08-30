//
//  FieldsView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 28.08.22.
//

import SwiftUI
import Combine

extension FieldsView {
    class ViewModel: ObservableObject {
        
        let session: Session
        let fieldService: FieldService
        let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            session: Session,
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.session = session
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            self.anyCancellable = Set()
        }
        
        func loadFields() {
            self.fieldService.getFields()
                .sink(
                    receiveCompletion: {_ in},
                    receiveValue: { fields in
                        for field in fields {
                            self.persistenceController.saveField(with: field)
                        }
                    }
                )
                .store(in: &anyCancellable)
        }
    }
}

struct FieldsView: View {
    
    @StateObject var viewModel: ViewModel
    @FetchRequest var fields: FetchedResults<Field>
    
    init(
        session: Session,
        fieldService: FieldService,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                session: session,
                fieldService: fieldService,
                persistenceController: persistenceController
            )
        )
        self._fields = FetchRequest(
            entity: Field.entity(),
            sortDescriptors: [
                NSSortDescriptor(key: "id", ascending: true)
            ],
            animation: .easeIn
        )
    }
    
    // MARK: temporary view
    var body: some View {
        Container {
            Text("Felder")
                .modifier(FontTitle())
                .modifier(Header())
            
            ForEach(fields) { field in
                NavigationLink(destination: detail(for: field)) {
                    ListItem(headline: field.name, subline: field.street)
                }
            }
        }
        .onAppear {
            viewModel.loadFields()
        }
    }
    
    func detail(for field: Field) -> some View {
        FieldDetailView(
            field,
            session: viewModel.session,
            fieldService: viewModel.fieldService,
            persistenceController: viewModel.persistenceController
        )
        .navigationLink()
    }
}

struct FieldsView_Previews: PreviewProvider {
    static var previews: some View {
        FieldsView(
            session: Session.preview,
            fieldService: FieldMockService(),
            persistenceController: .preview
        )
    }
}
