//
//  SeedOption.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 28.08.22.
//

import SwiftUI
import Combine

extension SeedingView {
    
    class ViewModel: ObservableObject {
        
        @Published var selectedSeeds: Set<Seed>
        
        private let fieldService: FieldService
        private let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            self.selectedSeeds = Set()
            self.anyCancellable = Set()
        }
        
        func isAvailable(_ seed: Seed) -> Bool {
            let points = UserDefaults.standard.double(for: .points) ?? 0
            let season = Season.current
            return seed.price <= Int(points) && seed.seasons.contains(season)
        }
        
        func isSelected(_ seed: Seed) -> Bool {
            self.selectedSeeds.contains(seed)
        }
        
        func select(_ seed: Seed) {
            guard isAvailable(seed) else {
                return
            }
            if self.selectedSeeds.contains(seed) {
                self.selectedSeeds.remove(seed)
            } else {
                self.selectedSeeds.insert(seed)
            }
        }
        
        func seed() {
            print("seed!")
        }
    }
}

struct SeedingView: View {
    
    @StateObject var viewModel: ViewModel
    var seeds: [Seed]
    
    init(
        seeds: [Seed],
        fieldService: FieldService,
        persistenceController: PersistenceController
    ) {
        self.seeds = seeds
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                fieldService: fieldService,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(seeds) { seed in
                    item(for: seed)
                        .onTapGesture {
                            viewModel.select(seed)
                        }
                }
            }
            .padding(.bottom, Spacing.large)
            
            ButtonIcon(
                "Jetzt planzen",
                icon: "plus",
                disabled: viewModel.selectedSeeds.isEmpty
            ) {
                viewModel.seed()
            }
        }
        .padding(Spacing.medium)
    }
    
    @ViewBuilder
    func item(for seed: Seed) -> some View {
        ZStack {
            Image(seed.name)
                .resizable()
                .scaledToFit()
                .padding(.bottom, Spacing.medium)
            
            VStack {
                Spacer()
                
                HStack {
                    Text(seed.name.uppercased())
                        .font(.custom(Font.normal, size: 12))
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.customOrange)
                            .frame(width: 20, height: 20)
                        
                        Text("\(seed.price)")
                            .font(.custom(Font.normal, size: 10))
                    }
                }
            }
            .padding(Spacing.extraSmall)
        }
        .aspectRatio(1/1, contentMode: .fit)
        .background(
            viewModel.isSelected(seed) ? Color.customLightBrown : Color.customLightBeige
        )
        .opacity(viewModel.isAvailable(seed) ? 1 : 0.6)
        .cornerRadius(18)
    }
}
