//
//  Points.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI
import Combine

struct Points: View {
    
    @State var value: Int
    @State var showAnimation: Bool
    
    @AppStorage var points: Double
    
    init() {
        self._points = AppStorage(wrappedValue: 0, .points)
        self._value = State(wrappedValue: 0)
        self._showAnimation = State(initialValue: false)
        self.value = Int(self.points)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.customOrange)
                .frame(width: circleSize, height: circleSize)
                .shadow(color: .shadow, radius: 6, x: 0, y: 3)
                .animation(.easeInOut, value: showAnimation)
            Text(showAnimation ? "\(value)" : "\(Int(points))")
                .modifier(FontHighlight())
        }
        .scaleEffect(showAnimation ? 1.1 : 1, anchor: .top)
        .onChange(of: points, perform: { _ in
            self.updateWithCountingAnimation()
        })
    }
    
    let circleSize: CGFloat = 50
    
    func updateWithCountingAnimation() {
        withAnimation {
            self.showAnimation = true
            
            let animationDuration = 1000
            let steps = min(abs(Int(self.points)), 100)
            let stepDuration = (animationDuration / steps)
            
            self.value += Int(self.points) % steps
            
            (0..<steps).forEach { step in
                let updateTimeInterval = DispatchTimeInterval.milliseconds(step * stepDuration)
                let deadline = DispatchTime.now() + updateTimeInterval
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    self.value += Int(Int(self.points) / steps)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.showAnimation = false
                }
            }
        }
    }
}

struct Points_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            HStack {
                Spacer()
                Points()
            }
           
            Button("Add") {
                UserDefaults.standard.set(90, for: .points)
            }
        }.onAppear {
            UserDefaults.standard.set(0, for: .points)
        }
    }
}
