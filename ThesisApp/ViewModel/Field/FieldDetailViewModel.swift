//
//  FieldDetailViewModel.swift
//  ThesisApp
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
        
        @Published var showPlantingMenu: Bool
        @Published var selectedPlant: Plant?
        
        @Published var selectedPosition: Position? {
            didSet {
                guard let position = selectedPosition else {
                    return
                }
                if let plant = field.hasPlant(at: position) {
                    selectedPlant = plant
                } else {
                    showPlantingMenu = true
                }
            }
        }
        
        let fieldService: FieldService
        let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            field: Field,
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            self.anyCancellable = Set()
            self.showPlantingMenu = false
            self.field = field
            
            self.field.objectWillChange.sink { [weak self] in
                self?.objectWillChange.send()
            }.store(in: &anyCancellable)
        }
    }
}
