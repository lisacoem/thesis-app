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
    
    var containsPlant: Bool {
        didSet {
            geometry?.materials = materials
        }
    }
    
    init(row: Int32, column: Int32, containsPlant: Bool) {
        self.row = row
        self.column = column
        self.containsPlant = containsPlant
        super.init()
        self.geometry = createGeometry()
        self.position = Converter.vector(position: .init(row: row, column: column))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var materials: [SCNMaterial] {
        let top = SCNMaterial()
        top.diffuse.contents = containsPlant ? UIColor(Color.customOrange) : UIImage(named: "FieldTop")
        
        let edge = SCNMaterial()
        edge.diffuse.contents = UIImage(named: "FieldEdge")
        
        return [edge, edge, edge, edge, top, edge]
    }
    
    func createGeometry() -> SCNGeometry {
        let geometry = SCNBox(width: 1, height: 0.5, length: 1, chamferRadius: 0)
        geometry.materials = materials
        return geometry
    }
    
}
