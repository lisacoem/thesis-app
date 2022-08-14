//
//  Points.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

struct Points: View {
    var value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.orange)
                .frame(width: circleSize, height: circleSize)
                .shadow(color: .shadow, radius: 6, x: 0, y: 3)
            Text("\(value)")
                .font(.custom(Font.bold, size: FontSize.highlight))
        }
    }
    
    let circleSize: CGFloat = 60
}

struct Points_Previews: PreviewProvider {
    static var previews: some View {
        Points(26)
    }
}
