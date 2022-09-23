//
//  FieldBackground.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.08.22.
//

import SwiftUI
import SpriteKit


struct WeatherSceneView: View {
    
    var weather: Weather?
    var daytime: Daytime?
    
    init(_ weather: Weather? = nil, daytime: Daytime? = nil) {
        self.weather = weather
        self.daytime = daytime
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: daytime?.colors ?? [Color.background],
                startPoint: .top,
                endPoint: .bottom
            )
            
            if let scene = weatherScene {
                SpriteView(scene: scene, options: [
                    .allowsTransparency
                ])
            }
        }
        .ignoresSafeArea()
    }
    
    var weatherScene: SKScene? {
        switch weather {
        case .snow:
            return SnowScene()
        case .rain:
            return RainScene()
        default:
            return nil
        }
    }

}

struct WeatherScene_Previews: PreviewProvider {
    static var previews: some View {
        WeatherSceneView(.rain, daytime: .midday)
        WeatherSceneView(.snow, daytime: .midday)
    }
}
