//
//  FieldBackground.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 31.08.22.
//

import SwiftUI
import SpriteKit


struct WeatherScene: View {
    
    var weather: Weather?
    var daytime: Daytime?
    
    init(_ weather: Weather? = nil, daytime: Daytime? = nil) {
        self.weather = weather
        self.daytime = daytime
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: daytimeColors,
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
    
    var daytimeColors: [Color] {
        switch daytime {
        case .twilight:
            return [
                Color("TwilightStart"),
                Color("TwilightEnd")
            ]
        case .midday:
            return [
                Color("MiddayStart"),
                Color("MiddayEnd")
            ]
        case .night:
            return [
                Color("NightStart"),
                Color("NightEnd")
            ]
        case .none:
            return [Color.background]
        }
    }
}

struct WeatherScene_Previews: PreviewProvider {
    static var previews: some View {
        WeatherScene(.rain, daytime: .midday)
    }
}
