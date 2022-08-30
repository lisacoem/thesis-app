//
//  FieldSceneView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 29.08.22.
//

import SwiftUI
import SceneKit

extension FieldSceneView {
    class ViewModel: ObservableObject {
        @Published var scene: SCNScene?
        
        var cameraNode: SCNNode? {
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 2)
            return cameraNode
        }
        
        init() {
            scene = SCNScene()
        }
    }
}

struct FieldSceneView: View {
    
    @StateObject var viewModel: ViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue:
            ViewModel()
        )
    }
    
    var body: some View {
        SceneView(
            scene: viewModel.scene,
            pointOfView: viewModel.cameraNode,
            options: [
                .allowsCameraControl,
                .autoenablesDefaultLighting,
                .temporalAntialiasingEnabled
            ]
        )
    }
}

struct FieldSceneView_Previews: PreviewProvider {
    static var previews: some View {
        FieldSceneView()
    }
}
