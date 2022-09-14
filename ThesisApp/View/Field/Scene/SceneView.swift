//
//  FieldSceneView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 29.08.22.
//

import SwiftUI
import SceneKit
import Combine

struct SceneView: UIViewRepresentable {
    
    @ObservedObject var field: Field
    @Binding var selectedPosition: Position?
    
    private var sceneView: FieldScene
    
    init(
        _ field: Field,
        selectedPosition: Binding<Position?>
    ) {
        self.field = field
        self.sceneView = FieldScene(field: field)
        self._selectedPosition = selectedPosition
    }
    
    func makeUIView(context: Context) -> FieldScene {
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleTap(_:))
        )
        sceneView.addGestureRecognizer(tapGesture)
        return sceneView
    }

    func updateUIView(_ sceneView: FieldScene, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(sceneView, selectedPosition: $selectedPosition)
    }
}

extension SceneView {

    class FieldScene: SCNView {
        
        @ObservedObject var field: Field
        var cameraNode: SCNNode!
        
        init(field: Field) {
            self.field = field
            super.init(frame: .zero, options: nil)
            
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
            cameraNode.position = SCNVector3(-2, 4, -2)
            cameraNode.look(at: SCNVector3(0, 0, 0))
            scene?.rootNode.addChildNode(cameraNode)
        }

        func setupField() {
            for i in 0...field.rows {
                for j in 0...field.columns {
                    guard Double(i*j) <= field.size else { return }
                    createBox(at: SCNVector3(x: Float(i), y: 0, z: Float(j)))
                }
            }
            
            cameraNode.look(at: .init(
                x: Float(field.rows / 2),
                y: 0,
                z: Float(field.columns / 2)
            ))

        }

        func createBox(at position: SCNVector3) {
            let box = SCNBox(width: 1, height: 0.5, length: 1, chamferRadius: 0)
            
            let top = SCNMaterial()
            if field.plantWith(position: Converter.position(vector: position)) != nil {
                top.diffuse.contents = UIColor(Color.customOrange)
            } else {
                top.diffuse.contents = UIImage(named: "FieldTop")
            }
            
            let edge = SCNMaterial()
            edge.diffuse.contents = UIImage(named: "FieldEdge")
            
            box.materials = [edge, edge, edge, edge, top, edge]
        
            let boxNode = SCNNode(geometry: box)
            boxNode.position = position
            scene?.rootNode.addChildNode(boxNode)
        }
    }
}

extension SceneView {
    
    class Coordinator: NSObject {
        
        @Binding var selectedPosition: Position?
        private let sceneView: SCNView
        
        init(
            _ sceneView: SCNView,
            selectedPosition: Binding<Position?>
        ) {
            self.sceneView = sceneView
            self._selectedPosition = selectedPosition
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            let p = gestureRecognize.location(in: sceneView)
            let hitResults = sceneView.hitTest(p, options: [:])
        
            if hitResults.count > 0 {
                let result = hitResults[0]
                selectedPosition = Converter.position(vector: result.node.position)
                
                let material = result.node.geometry!.materials[(result.geometryIndex)]
                
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                SCNTransaction.completionBlock = {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.5
                    material.emission.contents = UIColor.black
                    SCNTransaction.commit()
                }
                material.emission.contents = UIColor(Color.customLightBrown)
                SCNTransaction.commit()
            }
        }
    }
}

