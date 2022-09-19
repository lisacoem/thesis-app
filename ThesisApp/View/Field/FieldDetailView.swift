//
//  FieldDetailView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import SwiftUI
import PartialSheet

struct FieldDetailView: View {

    var daytime: Daytime?
    var weather: Weather?
    
    @ObservedObject var field: Field
    @StateObject var viewModel: ViewModel
    
    init(
        field: Field,
        weather: Weather?,
        daytime: Daytime?,
        fieldService: FieldService,
        persistenceController: PersistenceController
    ) {
        self.field = field
        self.daytime = daytime
        self.weather = weather
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                field: field,
                fieldService: fieldService,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        ZStack {
            WeatherSceneView(weather, daytime: daytime)
            
            FieldSceneView(field, selectedPosition: $viewModel.selectedPosition)
            
            VStack(alignment: .leading, spacing: .large) {
                header
                Spacer()
                
                if let plant = viewModel.selectedPlant {
                    PlantStatus(plant)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    viewModel.selectedPlant = nil
                                }
                            }
                        }
                }
            }
            .modifier(ContentLayout())
        }
        .ignoresSafeArea()
        .partialSheet(
            isPresented: $viewModel.showPlantingMenu,
            type: .dynamic,
            iPhoneStyle: .init(
                background: .solid(Color.background),
                handleBarStyle: .none,
                cover: .disabled,
                cornerRadius: 25
            )
        ) {
            PlantingMenu(
                seeds: field.seeds,
                position: viewModel.selectedPosition!,
                isPresented: $viewModel.showPlantingMenu,
                fieldService: viewModel.fieldService,
                persistenceController: viewModel.persistenceController,
                unlockedAchievements: $viewModel.unlockedAchievements
            )
        }
        .achievementModal($viewModel.unlockedAchievements)
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: .extraSmall) {
            fieldName
            Spacer()
            Points()
        }
    }
    
    var fieldName: some View {
        VStack(alignment: .leading, spacing: .small) {
            Text(field.name)
                .foregroundColor(daytime == .night ? .background : .customBlack)
                .modifier(FontTitle())
            Text(field.street)
                .foregroundColor(daytime == .night ? .background : .customBlack)
                .modifier(FontH4())
        }
    }

}

struct FieldDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let fieldService = FieldMockService()
        let persistenceController = PersistenceController.preview
        
        let fields = fieldService.fields.map {
            persistenceController.save(with: $0)
        }
        
        FieldDetailView(
            field: fields.first!,
            weather: nil,
            daytime: .twilight,
            fieldService: FieldMockService(),
            persistenceController: persistenceController
        )
        .attachPartialSheetToRoot()
    }
}
