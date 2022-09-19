//
//  SnowScene.swift
//  ThesisApp
//
//  SpriteKit Scene of Snow Animation
//
//  Created by Lisa Wittmann on 17.09.22.
//

import SwiftUI
import SpriteKit

class SnowScene: SKScene {
    
    override func sceneDidLoad() {
        self.size = UIScreen.main.bounds.size
        self.scaleMode = .resizeFill
        
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let node = SKEmitterNode(fileNamed: "Snow.sks")!

        node.particlePositionRange.dx = UIScreen.screenWidth
        self.addChild(node)
    }
}
