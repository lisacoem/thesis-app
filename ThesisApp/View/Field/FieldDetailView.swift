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
        
        @Published var isOverlayOpen: Bool
        
        let daytime: Daytime?
        let fieldService: FieldService
        let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            daytime: Daytime?,
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.daytime = daytime
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            self.anyCancellable = Set()
            self.isOverlayOpen = false
        }
        
        var textColor: Color {
            if let daytime = self.daytime, daytime == .night {
                return .background
            }
            return .customBlack
        }
    }
}

struct FieldDetailView: View {
    
    var field: Field
    
    @StateObject var viewModel: ViewModel
    @AppStorage var points: Double
    
    init(
        _ field: Field,
        daytime: Daytime?,
        fieldService: FieldService,
        persistenceController: PersistenceController
    ) {
        self.field = field
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                daytime: daytime,
                fieldService: fieldService,
                persistenceController: persistenceController
            )
        )
        self._points = AppStorage(wrappedValue: 0, .points)
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
            SeedingView(
                seeds: field.seeds,
                fieldService: viewModel.fieldService,
                persistenceController: viewModel.persistenceController
            )
        }
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: Spacing.extraSmall) {
            fieldName
            Spacer()
            Points(points)
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
            daytime: .midday,
            fieldService: FieldMockService(),
            persistenceController: persistenceController
        )
        .attachPartialSheetToRoot()
    }
}
