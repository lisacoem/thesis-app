//
//  TimeTracker.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct TimeTracker: View {
    
    var time: String
    var seconds: String?
    
    init(_ time: String, seconds: String? = nil) {
        self.time = time
        self.seconds = seconds
    }
    
    var body: some View {
        VStack {
            Image(systemName: "clock")
                .frame(maxWidth: .infinity,
                       alignment: .center)
                .frame(height: iconSizeLarge)
                .font(.custom(fontBold, size: iconSizeLarge))
                .foregroundColor(colorBlack)
                
            HStack(alignment: .bottom) {
                Text(time)
                    .font(.custom(fontBold, size: fontSizeHighlight))
                
                if let seconds = seconds {
                    Text(seconds)
                        .font(.custom(fontNormal, size: fontSizeText))
                        .foregroundColor(colorOrange)
                        .frame(height: iconSizeLarge)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct TimeTracker_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TimeTracker("1h 5m")
            TimeTracker("1h 5m", seconds: "5s")
        }
    }
}