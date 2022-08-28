//
//  FieldDetailView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import SwiftUI
import PartialSheet
import Combine

extension FieldDetailView {
    class ViewModel: ObservableObject {
        
        @Published var daytime: Daytime?
        @Published var isOverlayOpen: Bool
        
        private let session: Session
        let fieldService: FieldService
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            field: Field,
            session: Session,
            fieldService: FieldService
        ) {
            self.session = session
            self.fieldService = fieldService
            self.anyCancellable = Set()
            self.isOverlayOpen = false
            self.getDaytime(at: field)
        }
        
        var textColor: Color {
            if let daytime = self.daytime, daytime == .night {
                return .background
            }
            return .customBlack
        }
        
        var points: Int {
            if let sessionPoints = session.points {
                return Int(sessionPoints)
            }
            return 0
        }
        
        func getDaytime(at field: Field) {
            fieldService.getDaytime(at: field)
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

struct FieldDetailView: View {
    
    var field: Field
    
    @StateObject var viewModel: ViewModel
    
    init(
        _ field: Field,
        session: Session,
        fieldService: FieldService
    ) {
        self.field = field
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                field: field,
                session: session,
                fieldService: fieldService
            )
        )
    }
    
    var body: some View {
        ZStack {
            if let daytime = viewModel.daytime {
                LinearGradient(
                    colors: daytime.colors,
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                Color.background
            }
            
            VStack(
                alignment: .leading,
                spacing: Spacing.large
            ) {
                header
                Spacer()
                ButtonIcon("Punkte eintauschen", icon: "plus") {
                    viewModel.isOverlayOpen = true
                }
            }
            .modifier(ContentLayout())
        }
        .ignoresSafeArea()
        .partialSheet(
            isPresented: $viewModel.isOverlayOpen,
            type: .dynamic,
            iPhoneStyle: .init(
                background: .solid(Color.background),
                handleBarStyle: .none,
                cover: .disabled,
                cornerRadius: 25
            )
        ) {
            VStack(alignment: .leading, spacing: Spacing.extraLarge) {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: 3),
                    spacing: Spacing.small
                ) {
                    ForEach(Array(field.seeds), id: \.id) { seed in
                        SeedOption(seed)
                    }
                }
                .padding(.top, Spacing.large)
                
                ButtonIcon("Jetzt planzen", icon: "plus") {}
            }
            .padding(Spacing.medium)
        }
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: Spacing.extraSmall) {
            fieldName
            Spacer()
            Points(viewModel.points)
        }
        .modifier(Header())
    }
    
    var fieldName: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Biohof Günther")
                .foregroundColor(viewModel.textColor)
                .modifier(FontTitle())
            Text("Außerhalb 2")
                .foregroundColor(viewModel.textColor)
                .modifier(FontH4())
        }
    }
    
    var seeds: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(field.seeds) { seed in
                    SeedOption(seed)
                }
            }
            Spacer()
            ButtonIcon("Jetzt planzen", icon: "plus") {}
        }
    }
}

struct FieldDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let fieldService = FieldMockService()
        let persistenceController = PersistenceController.preview
        let fields = fieldService.fields.map {
            Field(
                with: $0,
                in: persistenceController.container.viewContext
            )
        }
        
        FieldDetailView(
            fields.first!,
            session: Session.preview,
            fieldService: FieldMockService()
        )
        .attachPartialSheetToRoot()
    }
}
