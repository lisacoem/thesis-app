//
//  WeatherAnimations.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.08.22.
//

import SwiftUI
import SpriteKit

class RainScene: SKScene {
    
    override func sceneDidLoad() {
        self.size = UIScreen.main.bounds.size
        self.scaleMode = .resizeFill
        
        self.backgroundColor = .black.withAlphaComponent(0.2)
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let node = SKEmitterNode(fileNamed: "Rain.sks")!

        node.particlePositionRange.dx = UIScreen.screenWidth
        self.addChild(node)
    }
}

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
