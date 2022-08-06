//
//  DistanceTracker.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct DistanceTracker: View {
    
    var distance: Float
    var movement: Movement
    
    init(_ movement: Movement, distance: Float) {
        self.movement = movement
        self.distance = distance
    }
    
    var body: some View {
        VStack {
            Image(systemName: movement.icon)
                .frame(maxWidth: .infinity,
                       alignment: .center)
                .frame(height: 30)
                .font(.custom(fontBold, size: 30))
                .foregroundColor(colorBlack)
                
            Text("\(distance.toString()) km")
                .font(.custom(fontBold, size: 35))
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
