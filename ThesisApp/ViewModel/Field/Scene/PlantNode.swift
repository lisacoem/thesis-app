//
//  PlantNode.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 20.09.22.
//

import SwiftUI
import SceneKit
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
    
    private var iterations: Int {
        Int(floor(plant.progress * Double(plant.system.iterations)))
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
    
    /// <#Description#>
    private func create() {
        self.currentNode = self.createNode()
        for symbol in plant.system.symbols(for: iterations) {
            self.create(from: symbol)
        }
    }
    
    private func create(from sequence: String.SubSequence) {
        print("sequence: \(sequence)")
        let parameterDelimiters = Set<Character>("(,)")
        let parameters = sequence
            .split(whereSeparator: parameterDelimiters.contains)
            .compactMap { Float($0) }
        
        print("parameters: \(parameters)")
        
        guard let symbol = LindenmayerSymbol(rawValue: sequence.first!) else {
            return
        }
        
        switch symbol {
            case .forward:
                move(with: parameters.first ?? defaultStepSize)
                break
            case .turnLeft:
                rotate(on: SCNVector3(0, 0, 1), angle: parameters.first ?? defaultAngle)
                break
            case .turnRight:
                rotate(on: SCNVector3(0, 0, -1), angle: parameters.first ?? defaultAngle)
                break
            case .rollLeft:
                rotate(on: SCNVector3(1, 0, 0), angle: parameters.first ?? defaultAngle)
                break
            case .rollRight:
                rotate(on: SCNVector3(-1, 0, 0), angle: parameters.first ?? defaultAngle)
                break
            case .pitchUp:
                rotate(on: SCNVector3(0, 1, 0), angle: parameters.first ?? defaultAngle)
                break
            case .pitchDown:
                rotate(on: SCNVector3(0, -1, 0), angle: parameters.first ?? defaultAngle)
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
        }
    }
    
    /// <#Description#>
    private func createBranch() {
        positionStack.append(currentPosition.copy())
        rotationStack.append(currentRotation.copy())
        currentNode = createNode()
    }
    
    /// <#Description#>
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - axis: <#axis description#>
    ///   - angle: <#angle description#>
    private func rotate(on axis: SCNVector3, angle: Float) {
        currentRotation.multiply(
            axis: axis,
            angle: Converter.radians(degrees: angle)
        )
    }
    
    /// <#Description#>
    /// - Parameter stepsize: <#stepsize description#>
    private func move(with stepsize: Float) {
        var movement = SCNVector3(0, 1, 0)
        movement.applyQuaternion(currentRotation.copy())
        movement.multiplyScalar(stepsize)
        currentPosition.add(movement)
        currentNode.add(point: currentPosition)
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    private func createNode() -> SCNLineNode {
        let line = SCNLineNode(
            with: [currentPosition],
            radius: plant.system.radius,
            edges: 12,
            maxTurning: 16
        )
        
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = UIColor(Color.customGreen)
        line.lineMaterials = [material]
        
        drawingNodes.append(line)
        addChildNode(line)
        return line
    }

}
