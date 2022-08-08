//
//  DistanceTracker.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct DistanceTracker: View {
    
    var distance: Double
    var movement: Movement
    
    init(_ movement: Movement, distance: Double) {
        self.movement = movement
        self.distance = distance
    }
    
    var body: some View {
        VStack {
            Image(systemName: movement.symbol)
                .frame(maxWidth: .infinity,
                       alignment: .center)
                .frame(height: iconSizeLarge)
                .font(.custom(fontBold, size: iconSizeLarge))
                .foregroundColor(colorBlack)
                
            Text("\(distance.toString()) km")
                .font(.custom(fontBold, size: fontSizeHighlight))
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct MovementTracker_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            DistanceTracker(.Walking, distance: 8.6)
            DistanceTracker(.Cycling, distance: 20.1)
        }
    }
}
