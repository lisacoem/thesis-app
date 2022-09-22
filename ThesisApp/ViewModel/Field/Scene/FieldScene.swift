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
    @AppStorage var userId: Int
    
    private var cameraNode: SCNNode

    private var fieldNodes: Set<FieldNode>
    private var userColors: Dictionary<Int64, UIColor>
    
    private var cancellables: Set<AnyCancellable>
    
    init(_ field: Field) {
        self._userId = AppStorage(wrappedValue: 0, .userId)
        self.field = field
        
        self.cameraNode = SCNNode()
        
        self.fieldNodes = Set()
        self.userColors = Dictionary()
        
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
    private func setupLight() {
        let light = SCNLight()
        light.type = .omni
        light.intensity = 100
        light.shadowSampleCount = 1
        light.shadowMode = .forward
        light.shadowColor = UIColor(white: 0, alpha: 0.75)
        
        var lightPosition = centerPoint.copy()
        lightPosition.add(SCNVector3(0, 40, 0))
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = lightPosition
        lightNode.castsShadow = true
        
        self.scene?.rootNode.addChildNode(lightNode)

        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 150

        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        self.scene?.rootNode.addChildNode(ambientLightNode)
    }
    
    /// add camera node to scene
    private func setupCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(-2, 4, -2)
        cameraNode.look(at: SCNVector3(0, 0, 0))
        scene?.rootNode.addChildNode(cameraNode)
    }
    
    /// add field nodes to scene
    private func setupField() {
        for row in 0...field.rows {
            for column in 0...field.columns {
                guard Double(row * column) <= field.size else {
                    return
                }
                let plant = field.plant(row: row, column: column)
                
                let fieldNode = FieldNode(
                    row: row,
                    column: column,
                    plant: plant,
                    color: getFieldColor(for: plant)
                )
                fieldNodes.insert(fieldNode)
                scene?.rootNode.addChildNode(fieldNode)
            }
        }

        cameraNode.look(at: centerPoint)
    }
    
    private var centerPoint: SCNVector3 {
        SCNVector3(Float(field.rows) / 2, 0 , Float(field.columns) / 2)
    }

    
    /// update field nodes to new field data
    private func updateField() {
        for node in self.fieldNodes {
            node.plant = field.plant(row: node.row, column: node.column)
            node.color = getFieldColor(for: node.plant)
        }
    }
    
    private func getFieldColor(for plant: Plant?) -> UIColor? {
        guard let plant = plant else {
            return nil
        }
        if let color = userColors[plant.user.id] {
            return color
        } else {
            let color: UIColor = userId == plant.user.id ? .init(Color.customBeige) : .random()
            userColors[plant.user.id] = color
            return color
        }
        
    }
}
