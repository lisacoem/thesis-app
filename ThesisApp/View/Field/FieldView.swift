//
//  FieldView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 28.08.22.
//

import SwiftUI

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
                NSSortDescriptor(
                    keyPath: \Field.id,
                    ascending: true
                )
            ],
            animation: .easeIn
        )
    }
    
    var body: some View {
        List {
            Section {
                ForEach(fields) { field in
                    item(for: field)
                }
            }
            header: {
                header
                    .spacing(.top, .extraLarge)
                    .spacing(.bottom, .large)
            }
        }
        .modifier(ListStyle())
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: .extraSmall) {
            Text("Felder")
                .modifier(FontTitle())
            Spacer()
            Points()
        }
        .modifier(HeaderLayout())
    }
    
    func item(for field: Field) -> some View {
        ListItem(
            headline: field.name,
            subline: field.street
        )
        .background(
            NavigationLink(destination: detail(for: field)) {
                EmptyView()
            }.opacity(0)
        )
        .listRowSeparator(.hidden)
        .listRowBackground(Color.background)
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
