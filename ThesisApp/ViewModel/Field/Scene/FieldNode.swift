//
//  FieldNode.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 17.09.22.
//

import SwiftUI
import SceneKit

class FieldNode: SCNNode {
    
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
        self.position = Converter.vector(position: .init(row: row, column: column))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var plantNode: PlantNode?
    var floorNode: SCNNode
    
    private var floorMaterials: [SCNMaterial] {
        let top = SCNMaterial()
        
        if let color = self.color {
            top.diffuse.contents = color
        } else {
            top.diffuse.contents = UIImage(named: "FieldTop")
        }
        
        let edge = SCNMaterial()
        edge.diffuse.contents = UIImage(named: "FieldEdge")
        
        return [edge, edge, edge, edge, top, edge]
    }
    
    private func createFloor() {
        let floor = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        floor.materials = floorMaterials
        floorNode = SCNNode(geometry: floor)
        addChildNode(floorNode)
    }
    
    private func createPlant() {
        if let plant =  self.plant {
            let node = PlantNode(plant)
            if let lastNode = plantNode {
                replaceChildNode(lastNode, with: node)
                plantNode = node
            } else {
                addChildNode(node)
                plantNode = node
            }
        }
    }
    
}
