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
    
    @ObservedObject var plant: Plant
    
    init(_  plant: Plant) {
        self.plant = plant
        
        self.positionStack = []
        self.rotationStack = []
        self.drawingNodes = []
        
        self.currentPosition = SCNVector3(0, 0, 0)
        self.currentRotation = SCNQuaternion(0, 0, 0, 1)
        self.currentNode = .init()
                
        self.cancellables = Set()

        super.init()
        self.castsShadow = true
        
        self.plant.objectWillChange.sink { _ in
            self.update()
        }.store(in: &cancellables)

        self.position = SCNVector3(0, 0.5, 0)
        self.create()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var iterations: Int {
        Int(floor(plant.progress * Double(plant.system.iterations)))
    }
    
    private var cancellables: Set<AnyCancellable>
    
    private var currentPosition: SCNVector3
    private var currentRotation: SCNQuaternion
    private var currentNode: SCNLineNode
    
    private var positionStack: [SCNVector3]
    private var rotationStack: [SCNQuaternion]
    private var drawingNodes: [SCNLineNode]
    
    private func create() {
        self.currentNode = self.createNode()
        for symbol in plant.system.sentence(for: iterations) {
            self.create(from: symbol)
        }
    }
    
    private func create(from symbol: Character) {
        guard let operand = Operand(rawValue: symbol) else {
            return
        }
        switch operand {
            case .forward:
                move()
                break
            case .right:
                rotate(on: SCNVector3(0, 0, 1))
                break
            case .left:
                rotate(on: SCNVector3(0, 0, -1))
                break
            case .rollRight:
                rotate(on: SCNVector3(-1, 0, 0))
                break
            case .rollLeft:
                rotate(on: SCNVector3(1, 0, 0))
                break
            case .up:
                rotate(on: SCNVector3(0, 1, 0))
                break
            case .down:
                rotate(on: SCNVector3(0, -1, 0))
                break
            case .startBranch:
                createBranch()
                break
            case .endBranch:
                leaveBranch()
                break
        }
    }
    
    private func createBranch() {
        positionStack.append(currentPosition.copy())
        rotationStack.append(currentRotation.copy())
        currentNode = createNode()
    }
    
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
    
    private func rotate(on axis: SCNVector3) {
        currentRotation.multiply(axis: axis, angle: plant.system.angle)
    }
    
    private func move() {
        var movement = SCNVector3(0, 1, 0)
        movement.applyQuaternion(currentRotation.copy())
        movement.multiplyScalar(plant.system.length)
        currentPosition.add(movement)
        currentNode.add(point: currentPosition)
    }
    
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
    
    func update() {
        print("update")
    }
}
