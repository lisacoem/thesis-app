//
//  FieldSceneView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 29.08.22.
//

import SwiftUI
import SceneKit
import Combine

struct FieldScene: UIViewRepresentable {
    
    var field: Field
    
    init(_ field: Field) {
        self.field = field
    }
    
    func makeUIView(context: Context) -> Scene {
        Scene(field: field)
    }

    func updateUIView(_ sceneView: Scene, context: Context) { }

}

extension FieldScene {

    class Scene: SCNView {
        
        var field: Field
        var cameraNode: SCNNode!
        
        init(field: Field) {
            self.field = field
            super.init(frame: .zero, options: nil)
            
            self.scene = SCNScene()
            self.scene?.background.contents = UIColor.clear
            self.backgroundColor = .clear
        
            self.allowsCameraControl = true
            self.autoenablesDefaultLighting = true

            self.setupCamera()
            self.setupField()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
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
        
        func setupCamera() {
            cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(-5, 5, -5)
            cameraNode.look(at: SCNVector3(0, 0, 0))
            scene?.rootNode.addChildNode(cameraNode)            
        }
        
        func setupField() {
            let length = Int(sqrt(field.size))
            let width = Int(sqrt(field.size))
            
            for i in 0...length {
                for j in 0...width {
                    createBox(at: SCNVector3(
                        x: Float(i),
                        y: 0,
                        z: Float(j)
                    ))
                }
            }
            
            cameraNode.look(at: .init(
                x: Float(length),
                y: 0,
                z: Float(width)
            ))

        }
        
        func createBox(at position: SCNVector3) {
            let box = SCNBox(
                width: 1,
                height: 0.5,
                length: 1,
                chamferRadius: 0.0
            )
            box.firstMaterial?.diffuse.contents = UIColor(.customBrown)
            
            let boxNode = SCNNode(geometry: box)
            boxNode.position = position
            scene?.rootNode.addChildNode(boxNode)
        }
    }
}

