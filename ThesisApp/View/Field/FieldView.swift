//
//  FieldView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 28.08.22.
//

import SwiftUI
import Combine

extension FieldView {
    class ViewModel: ObservableObject {
        
        @Published var daytime: Daytime?
        
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
            self.getDaytime()
            
            self.session.objectWillChange
                .sink { [weak self] in
                    self?.objectWillChange.send()
                }
                .store(in: &anyCancellable)
        }
        
        var points: Int {
            if let sessionPoints = session.points {
                return Int(sessionPoints)
            }
            return 0
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
        
        func getDaytime() {
            fieldService.getDaytime()
                .sink(
                    receiveCompletion: {_ in},
                    receiveValue: { daytime in
                        self.daytime = daytime
                    }
                )
                .store(in: &anyCancellable)
        }
    }
}

struct FieldView: View {
    
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
            header
            
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
    
    var header: some View {
        HStack(alignment: .top, spacing: Spacing.extraSmall) {
            Text("Felder")
                .modifier(FontTitle())
            
            Spacer()
            
            Points(viewModel.points)
        }
        .modifier(Header())
    }
    
    func detail(for field: Field) -> some View {
        FieldDetailView(
            field,
            daytime: viewModel.daytime,
            session: viewModel.session,
            fieldService: viewModel.fieldService,
            persistenceController: viewModel.persistenceController
        )
        .navigationLink()
    }
}

struct FieldsView_Previews: PreviewProvider {
    static var previews: some View {
        FieldView(
            session: Session.preview,
            fieldService: FieldMockService(),
            persistenceController: .preview
        )
    }
}
