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
    
    var daytime: Daytime?
    @ObservedObject var field: Field
    
    init(_ field: Field, daytime: Daytime? = nil) {
        self._userId = AppStorage(wrappedValue: 0, .userId)
        self.field = field
        self.daytime = daytime
        
        self.cameraNode = SCNNode()
        self.daylightNode = SCNNode()
        
        self.fieldNodes = Set()
        self.userColors = Dictionary()
        
        self.cancellables = Set()
        
        super.init(frame: .zero, options: nil)
        
        // update view if field object publishes changes
        self.field.objectWillChange.sink { [weak self] in
            self?.updateField()
        }.store(in: &cancellables)

        self.setupScene()
    }
    
    @AppStorage private var userId: Int
    
    private var userColors: Dictionary<Int64, UIColor>

    private var cameraNode: SCNNode
    private var daylightNode: SCNNode
    
    private var fieldNodes: Set<FieldNode>
    
    private var cancellables: Set<AnyCancellable>
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var centerPoint: SCNVector3 {
        .init(Float(field.rows / 2), 0, Float(field.columns / 2))
    }
    
    private func setupScene() {
        scene = SCNScene()
        scene?.background.contents = UIColor.clear
        backgroundColor = .clear
    
        allowsCameraControl = true
        defaultCameraController.interactionMode = .orbitTurntable
        defaultCameraController.minimumVerticalAngle = 20
        defaultCameraController.maximumVerticalAngle = 175
        
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.gray
        scene?.rootNode.light = ambientLight
        
        self.setupCamera()
        self.setupField()
        
        if daytime != .night {
            self.setupDaylight()
        }
    }
    
    /// Add spotlight node as sun to scene
    private func setupDaylight() {
        let light = SCNLight()
        light.type = .spot
        light.spotInnerAngle = 30
        light.spotOuterAngle = 80
        light.intensity = 500
        light.castsShadow = true
        light.zFar = 1000
        
        light.shadowColor = UIColor(white: 0, alpha: 0.75)
        light.color = UIColor(
            red: 0.95,
            green: 0.8,
            blue: 0.8,
            alpha: 1
        )
        
        daylightNode.position = centerPoint
        scene?.rootNode.addChildNode(daylightNode)
        
        let constraint = SCNLookAtConstraint(target: daylightNode)
        constraint.isGimbalLockEnabled = true
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 100, 0)
        lightNode.constraints = [constraint]
        daylightNode.addChildNode(lightNode)
        
        if daytime == .dawn {
            daylightNode.runAction(
                SCNAction.rotateBy(
                    x: -.pi / 3,
                    y: 0,
                    z: -.pi / 3,
                    duration: 0.0
                )
            )
        }
        if daytime == .dusk {
            daylightNode.runAction(
                SCNAction.rotateBy(
                    x: .pi / 3,
                    y: 0,
                    z: .pi / 3,
                    duration: 0.0
                )
            )
        }
    }
    
    /// Add camera node to scene
    private func setupCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(-2, 4, -2)

        cameraNode.look(at: centerPoint)
        scene?.rootNode.addChildNode(cameraNode)
    }
    
    /// Add field nodes to scene
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
                    color: getColor(by: plant?.user.id)
                )
                fieldNodes.insert(fieldNode)
                scene?.rootNode.addChildNode(fieldNode)
            }
        }
    }
    
    /// Update field nodes to new field data
    private func updateField() {
        for node in self.fieldNodes {
            node.plant = field.plant(row: node.row, column: node.column)
            node.color = getColor(by: node.plant?.user.id)
        }
    }
    
    /// Get color of field node by user id. Store colors with id, to highlighted all plants of a user in the same color
    /// - Parameter id: user id
    /// - Returns: Stored color of user or nil if id is nil
    private func getColor(by id: Int64?) -> UIColor? {
        guard let id = id else {
            return nil
        }
        if let color = userColors[id] {
            return color
        } else {
            let color: UIColor = userId == id ? .init(Color.customBeige) : .random()
            userColors[id] = color
            return color
        }
    }
}
