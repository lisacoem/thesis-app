//
//  PlantNode.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 20.09.22.
//

import SwiftUI
import SceneKit
import SceneKit.ModelIO
import SCNLine
import Combine

class PlantNode: SCNNode {
    
    var plant: Plant
    
    init(_  plant: Plant) {
        self.plant = plant
        
        self.positionStack = []
        self.rotationStack = []
        self.drawingNodes = []
        
        self.currentPosition = SCNVector3(0, 0, 0)
        self.currentRotation = SCNQuaternion(0, 0, 0, 1)
        self.currentNode = .init()

        super.init()

        self.position = SCNVector3(0, 0.5, 0)
        self.create()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var currentPosition: SCNVector3
    private var currentRotation: SCNQuaternion
    private var currentNode: SCNLineNode
    
    private var positionStack: [SCNVector3]
    private var rotationStack: [SCNQuaternion]
    private var drawingNodes: [SCNLineNode]
    
    private var defaultAngle: Float {
        plant.system.angle
    }
    
    private var defaultStepSize: Float {
        plant.system.length
    }
    
    private var iterations: Int {
        // convert plant progress into lindenmayer iteration
        Int(floor(plant.progress * Double(plant.system.iterations)))
    }

    
    /// Start creating the plant structure with the current growth state
    private func create() {
        self.currentNode = self.createNode()
        for segment in plant.system.segments(for: iterations) {
            self.create(from: segment)
        }
    }
    
    private func create(from segment: LindenmayerSegment) {
        switch segment.symbol {
        case .forward:
            move(with: segment.parameters.first ?? defaultStepSize)
            break
        case .turnLeft:
            rotate(
                on: SCNVector3(0, 0, 1),
                angle: segment.parameters.first ?? defaultAngle
            )
            break
        case .turnRight:
            
            rotate(
                on: SCNVector3(0, 0, -1),
                angle: segment.parameters.first ?? defaultAngle
            )
            break
        case .rollLeft:
            rotate(
                on: SCNVector3(1, 0, 0),
                angle: segment.parameters.first ?? defaultAngle
            )
            break
        case .rollRight:
            rotate(
                on: SCNVector3(-1, 0, 0),
                angle: segment.parameters.first ?? defaultAngle
            )
            break
        case .pitchUp:
            rotate(
                on: SCNVector3(0, 1, 0),
                angle: segment.parameters.first ?? defaultAngle
            )
            break
        case .pitchDown:
            rotate(
                on: SCNVector3(0, -1, 0),
                angle: segment.parameters.first ?? defaultAngle
            )
            break
        case .turnAround:
            rotate(on: .zAxis, angle: 180)
            break
        case .startBranch:
            createBranch()
            break
        case .endBranch:
            leaveBranch()
            break
        case .leaf:
            loadObject("leaf")
            break
        case .bud:
            loadObject("bud")
            break
        case .flower:
            loadObject("flower")
            break
        case .fruit:
            loadObject("fruit")
            break
        }
    }
    
    /// Push the current state of the turtle onto a pushdown stack.
    /// The information saved on the stack contains the turlte's position and orientation.
    /// see: the algorithmic beauty of plants (P Prusinkiewicz, A Lindenmayer)
    private func createBranch() {
        positionStack.append(currentPosition.copy())
        rotationStack.append(currentRotation.copy())
        currentNode = createNode()
    }
    
    /// Pop a state from the stack and make it the current state of the turtle.
    /// No line is drawn, althought in genereal the position of the turtle changes.
    /// see: the algorithmic beauty of plants (P Prusinkiewicz, A Lindenmayer)
    private func leaveBranch() {
        if let storedPosition = positionStack.popLast() {
            self.currentPosition = storedPosition
        }
        
        if let storedRotation = rotationStack.popLast() {
            self.currentRotation = storedRotation
        }
        
        if let storedNode = drawingNodes.popLast() {
            self.currentNode = storedNode
        }
    }
    
    /// Rotate turtle on axis by angle
    /// - Parameters:
    ///   - axis: normalized axis vector
    ///   - angle: rotation angle in degrees
    private func rotate(on axis: SCNVector3, angle: Float) {
        currentRotation.multiply(
            axis: axis,
            angle: Converter.radians(degrees: angle)
        )
    }
    
    /// Move turtle forward. Multiply current rotation to the directional vector
    /// - Parameter stepsize: length of the step forward
    private func move(with stepsize: Float) {
        var movement = SCNVector3(0, 1, 0)
        movement.applyQuaternion(currentRotation.copy())
        movement.multiplyScalar(stepsize)
        currentPosition.add(movement)
        currentNode.add(point: currentPosition)
    }
    
    /// Create a new node (e.g stamp or branch)
    /// - Returns: line node representing stamp or branch of plant
    private func createNode() -> SCNLineNode {
        let line = SCNLineNode(
            with: [currentPosition],
            radius: plant.system.radius
        )
        
        let color = UIColor(hex: plant.system.color)
        let defaultColor = UIColor(Color.customGreen)
        
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = color ?? defaultColor
        line.lineMaterials = [material]
        
        drawingNodes.append(line)
        addChildNode(line)
        return line
    }
    
    /// Load object from OBJ-File and add it to root node
    /// - Parameter type: object type
    func loadObject(_ type: String) {
        let object = SCNScene(named: "\(plant.name.lowercased())-\(type).obj")
        if let objectNode = object?.rootNode {
            objectNode.position = currentPosition
            objectNode.rotation = currentRotation
            addChildNode(objectNode)
        }
    }

}
