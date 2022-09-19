//
//  FieldDetailViewModel.swift
//  ThesisApp
//
//  ViewModel of FieldDetailView
//
//  Created by Lisa Wittmann on 14.09.22.
//

import Foundation
import SwiftUI
import Combine
import SceneKit

extension FieldDetailView {

    class ViewModel: ObservableObject {
        
        @ObservedObject var field: Field
        
        @Published var unlockedAchievements: [Achievement]?

        @Published var selectedPosition: Position? {
            didSet {
                guard let position = selectedPosition else {
                    showPlantingMenu = false
                    selectedPlant = nil
                    return
                }
                if let plant = field.plant(with: position) {
                    showPlantingMenu = false
                    selectedPlant = plant
                } else {
                    selectedPlant = nil
                    showPlantingMenu = true
                }
            }
        }
        
        @Published var showPlantingMenu: Bool
        @Published var selectedPlant: Plant?
        
        let fieldService: FieldService
        let persistenceController: PersistenceController
        
        var cancellables: Set<AnyCancellable>
        
        init(
            field: Field,
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            
            self.cancellables = Set()
            
            self.field = field
            self.showPlantingMenu = false
            
            self.field.objectWillChange.sink { [weak self] in
                self?.objectWillChange.send()
            }.store(in: &cancellables)
        }
    }
}
