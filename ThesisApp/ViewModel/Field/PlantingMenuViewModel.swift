//
//  PlantingViewModel.swift
//  ThesisApp
//
//  ViewModel of PlantingView
//
//  Created by Lisa Wittmann on 18.09.22.
//

import SwiftUI
import Combine

extension PlantingMenu {
    
    class ViewModel: ObservableObject {
        
        @Published var selectedSeed: Seed?
        
        @Binding var isPresented: Bool
        @Binding var unlockedAchievements: [Achievement]?
        
        private let position: Position
        private let fieldService: FieldService
        private let persistenceController: PersistenceController
        
        var cancellables: Set<AnyCancellable>
        
        init(
            position: Position,
            isPresented: Binding<Bool>,
            fieldService: FieldService,
            persistenceController: PersistenceController,
            unlockedAchievements: Binding<[Achievement]?>
        ) {
            self._isPresented = isPresented
            self._unlockedAchievements = unlockedAchievements
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            self.cancellables = Set()
            self.position = position
        }
        
        var plantingDisabled: Bool {
            selectedSeed == nil
        }
        
        func isAvailable(_ seed: Seed) -> Bool {
            let points = UserDefaults.standard.double(for: .points) ?? 0
            return seed.price <= Int(points)
        }
        
        func isSelected(_ seed: Seed) -> Bool {
            self.selectedSeed == seed
        }
        
        func select(_ seed: Seed) {
            guard isAvailable(seed) else {
                return
            }
            if selectedSeed == seed {
                self.selectedSeed = nil
            } else {
                self.selectedSeed = seed
            }
        }
        
        func createPlant() {
            guard let seed = selectedSeed else {
                return
            }
            
            self.fieldService.createPlant(
                .init(seedId: seed.id, position: position)
            )
            .sink(
                receiveCompletion: { _ in},
                receiveValue: resolve
            )
            .store(in: &cancellables)
        }
        
        func resolve(_ response: Achieved<FieldData>) {
            UserDefaults.standard.set(response.points, for: .points)

            _ = self.persistenceController.save(with: response.data)
            
            if !response.achievements.isEmpty {
                unlockedAchievements = response.achievements.map {
                    persistenceController.save(with: $0)
                }
            }
            
            self.selectedSeed = nil
            self.isPresented = false
        }
    }
}
