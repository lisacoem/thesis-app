//
//  FieldScene.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 17.09.22.
//

import SwiftUI
import SceneKit
import Combine

class FieldScene: SCNView {
    
    @ObservedObject var field: Field
    
    var cameraNode: SCNNode
    var fieldNodes: Set<FieldNode>
    
    var cancellables: Set<AnyCancellable>
    
    init(_ field: Field) {
        self.field = field
        
        self.fieldNodes = Set()
        self.cameraNode = SCNNode()
        
        self.cancellables = Set()
        
        super.init(frame: .zero, options: nil)
        
        // update view if field object publishes changes
        self.field.objectWillChange.sink { [weak self] in
            self?.updateField()
        }.store(in: &cancellables)
        
        self.scene = SCNScene()
        self.scene?.background.contents = UIColor.clear
        self.backgroundColor = .clear
    
        self.allowsCameraControl = true
        self.defaultCameraController.interactionMode = .orbitTurntable
        self.defaultCameraController.minimumVerticalAngle = 20
        self.defaultCameraController.maximumVerticalAngle = 179
        self.autoenablesDefaultLighting = true
        
        self.setupLight()
        self.setupCamera()
        self.setupField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// add light nodes to scene
    func setupLight() {
        let light = SCNLight()
        light.automaticallyAdjustsShadowProjection = true
        light.shadowSampleCount = 8
        light.shadowRadius = 5
        light.type = .directional
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(1.1, 1.65, 1)
        self.scene?.rootNode.addChildNode(lightNode)

        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 300

        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        self.scene?.rootNode.addChildNode(ambientLightNode)
    }
    
    /// add camera node to scene
    func setupCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(-2, 4, -2)
        cameraNode.look(at: SCNVector3(0, 0, 0))
        scene?.rootNode.addChildNode(cameraNode)
    }
    
    /// add field nodes to scene
    func setupField() {
        for row in 0...field.rows {
            for column in 0...field.columns {
                guard Double(row * column) <= field.size else {
                    return
                }
                let node = FieldNode(
                    row: row,
                    column: column,
                    containsPlant: field.containsPlant(row: row, column: column)
                )
                fieldNodes.insert(node)
                scene?.rootNode.addChildNode(node)
            }
        }

        cameraNode.look(at: .init(
            x: Float(field.rows / 2),
            y: 0,
            z: Float(field.columns / 2)
        ))

    }
    
    
    /// update field nodes to new field data
    func updateField() {
        for node in self.fieldNodes {
            node.containsPlant = field.containsPlant(row: node.row, column: node.column)
        }
    }
}
