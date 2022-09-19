//
//  PlantingView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 28.08.22.
//

import SwiftUI
import Combine

struct PlantingMenu: View {
    
    var seeds: [Seed]

    @StateObject var viewModel: ViewModel
    
    init(
        seeds: [Seed],
        position: Position,
        isPresented: Binding<Bool>,
        fieldService: FieldService,
        persistenceController: PersistenceController,
        unlockedAchievements: Binding<[Achievement]?>
    ) {
        self.seeds = seeds
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                position: position,
                isPresented: isPresented,
                fieldService: fieldService,
                persistenceController: persistenceController,
                unlockedAchievements: unlockedAchievements
            )
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .large) {
            LazyVGrid(columns: columns) {
                ForEach(seeds) { seed in
                    SeedItem(
                        seed: seed,
                        selected: viewModel.isSelected(seed),
                        available: viewModel.isAvailable(seed)
                    )
                    .onTapGesture {
                        viewModel.select(seed)
                    }
                }
            }
            .spacing(.vertical, .large)
            
            ButtonIcon("Jetzt planzen", icon: "plus", disabled: viewModel.plantingDisabled) {
                viewModel.createPlant()
            }
        }
        .spacing(.all, .medium)
    }
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 3)
    }
}
