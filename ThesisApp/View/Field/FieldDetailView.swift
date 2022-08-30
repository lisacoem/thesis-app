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
        let session: Session
        let fieldService: FieldService
        let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            daytime: Daytime?,
            session: Session,
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.daytime = daytime
            self.session = session
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
        
        var points: Int {
            if let sessionPoints = session.points {
                return Int(sessionPoints)
            }
            return 0
        }
    }
}

struct FieldDetailView: View {
    
    var field: Field
    
    @StateObject var viewModel: ViewModel
    
    init(
        _ field: Field,
        daytime: Daytime?,
        session: Session,
        fieldService: FieldService,
        persistenceController: PersistenceController
    ) {
        self.field = field
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                daytime: daytime,
                session: session,
                fieldService: fieldService,
                persistenceController: persistenceController
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
            SeedingView(
                seeds: field.seeds,
                session: viewModel.session,
                fieldService: viewModel.fieldService,
                persistenceController: viewModel.persistenceController
            )
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
            session: Session.preview,
            fieldService: FieldMockService(),
            persistenceController: persistenceController
        )
        .attachPartialSheetToRoot()
    }
}
