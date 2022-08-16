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
    
    @State var result: String
    @State var counter: String
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(startTime: Date = Date.now) {
        self._result = State(initialValue: "0h 0min")
        self._counter = State(initialValue: "0s")
        
        self.startTime = startTime
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        TimeTracker(result, seconds: counter)
            .onReceive(timer) { _ in
                updateTime()
            }
    }
    
    func updateTime() {
        let duration = Date().timeIntervalSince(startTime)
        self.result = Formatter.time(duration)
        self.counter = Formatter.seconds(duration)
    }
}

struct TimeCounter_Previews: PreviewProvider {
    static var previews: some View {
        Counter()
    }
}
