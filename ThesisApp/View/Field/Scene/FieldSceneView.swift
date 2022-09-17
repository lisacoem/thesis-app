//
//  FieldSceneView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 29.08.22.
//

import SwiftUI
import SceneKit
import Combine

struct FieldSceneView: UIViewRepresentable {
    
    @ObservedObject var field: Field
    @Binding var selectedPosition: Position?
    
    @State var sceneView: FieldScene
    
    init(
        _ field: Field,
        selectedPosition: Binding<Position?>
    ) {
        self.field = field
        self._sceneView = State(wrappedValue: FieldScene(field))
        self._selectedPosition = selectedPosition
    }
    
    func makeUIView(context: Context) -> FieldScene {
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleTap(_:))
        )
        sceneView.addGestureRecognizer(tapGesture)
        return sceneView
    }

    func updateUIView(_ sceneView: FieldScene, context: Context) {}
    
    func makeCoordinator() -> FieldSceneCoordinator {
        FieldSceneCoordinator(sceneView, selectedPosition: $selectedPosition)
    }
}

