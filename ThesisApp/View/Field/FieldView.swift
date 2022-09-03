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
        @Published var weather: Weather?
        
        let fieldService: FieldService
        let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            self.anyCancellable = Set()
            self.getDaytime()
        }
        
        func loadFields() {
            self.fieldService.getFields()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { fields in
                        for field in fields {
                            self.persistenceController.saveField(with: field)
                        }
                    }
                )
                .store(in: &anyCancellable)
        }
        
        func getDaytime() {
            fieldService.getWeather()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { data in
                        self.daytime = data.daytime
                        self.weather = data.weather
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
        fieldService: FieldService,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
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
    
    var body: some View {
        Container {
            header
            // MARK: temporary view
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
            
            Points()
        }
        .modifier(Header())
    }
    
    func detail(for field: Field) -> some View {
        FieldDetailView(
            field: field,
            weather: viewModel.weather,
            daytime: viewModel.daytime,
            fieldService: viewModel.fieldService,
            persistenceController: viewModel.persistenceController
        )
        .navigationLink()
    }
}

struct FieldsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            FieldView(
                fieldService: FieldMockService(),
                persistenceController: .preview
            )
        }
    }
}
