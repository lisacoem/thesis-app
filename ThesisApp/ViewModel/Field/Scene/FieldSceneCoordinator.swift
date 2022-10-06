//
//  FieldSceneCoordinator.swift
//  ThesisApp
//
//  Coordinator of FieldScene
//
//  Created by Lisa Wittmann on 17.09.22.
//

import SwiftUI
import SceneKit

class FieldSceneCoordinator: NSObject {
    
    @Binding var selectedPosition: Position?
    private let sceneView: SCNView
    
    init(
        _ sceneView: SCNView,
        selectedPosition: Binding<Position?>
    ) {
        self.sceneView = sceneView
        self._selectedPosition = selectedPosition
        super.init()
    }
    
    /// Highlight selected FieldNode on tap and bind FieldPosition on selectedPosition for handling in parent view
    /// - Parameter gestureRecognize: tap gesture recognizer
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let position = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(position, options: [:])
    
        if let result = hitResults.first, let fieldNode = result.node.parent as? FieldSegmentNode {
            selectedPosition = Position(row: fieldNode.row, column: fieldNode.column)
            
            let material = fieldNode.floorNode.geometry!.materials[(result.geometryIndex)]
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                material.emission.contents = UIColor.black
                SCNTransaction.commit()
            }
            material.emission.contents = UIColor(Color.customLightBrown)
            SCNTransaction.commit()
        }
    }
    
}
