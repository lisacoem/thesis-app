//
//  FieldSegmentNode.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 17.09.22.
//

import SwiftUI
import SceneKit

class FieldSegmentNode: SCNNode {
    
    let row: Int32
    let column: Int32
    
    var plant: Plant? {
        didSet {
            if plant != nil {
                createPlant()
            }
        }
    }

    var color: UIColor? {
        didSet {
            floorNode.geometry?.materials = floorMaterials
        }
    }
    
    init(row: Int32, column: Int32, plant: Plant?, color: UIColor? = nil) {
        self.row = row
        self.column = column
        self.plant = plant
        self.color = color
        
        self.plantNode = nil
        self.floorNode = .init()
        
        super.init()
        
        self.createFloor()
        self.createPlant()
        self.position = SCNVector3(Float(row), 0, Float(column))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var plantNode: PlantNode?
    var floorNode: SCNNode
    
    private var floorMaterials: [SCNMaterial] {
        let top = SCNMaterial()
        top.lightingModel = .lambert
        top.locksAmbientWithDiffuse = true
        
        if let color = self.color {
            top.diffuse.contents = color
        } else {
            top.diffuse.contents = UIImage(named: "FieldTop")
        }
        
        let edge = SCNMaterial()
        edge.diffuse.contents = UIImage(named: "FieldEdge")
        
        return [edge, edge, edge, edge, top, edge]
    }
    
    /// Create floor representation
    private func createFloor() {
        let floor = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        floor.materials = floorMaterials
        floorNode = SCNNode(geometry: floor)
        addChildNode(floorNode)
    }
    
    /// Create plant representation
    private func createPlant() {
        if let plant = self.plant {
            let node = PlantNode(plant)
            if let lastNode = plantNode {
                replaceChildNode(lastNode, with: node)
            } else {
                addChildNode(node)
            }
            plantNode = node
        }
    }
    
}
