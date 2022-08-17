//
//  Counter.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI
import Combine

struct Counter: View {
    
    var startTime: Date
    
    @State var counter: String
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(startTime: Date = Date.now) {
        self._counter = State(initialValue:
            Formatter.time(Date().timeIntervalSinceNow)
        )
        
        self.startTime = startTime
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        InfoItem(symbol: "clock", value: counter)
            .onReceive(timer) { _ in
                updateTime()
            }
    }
    
    func updateTime() {
        let duration = Date().timeIntervalSince(startTime)
        self.counter = Formatter.time(duration)
    }
}

struct TimeCounter_Previews: PreviewProvider {
    static var previews: some View {
        Counter()
    }
}
