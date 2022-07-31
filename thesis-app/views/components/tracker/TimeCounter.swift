//
//  TimeCounter.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI
import Combine

struct TimeCounter: View {
    
    var startTime: Date
    
    @Binding var running: Bool
    @Binding var value: TimeInterval
    
    @State var result: String
    @State var counter: String
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(_ value: Binding<TimeInterval>, running: Binding<Bool>, startTime: Date = Date.now) {
        self._value = value
        self._running = running
        
        self._result = State(initialValue: "0h 0m")
        self._counter = State(initialValue: "0s")
        
        self.startTime = startTime
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        TimeTrack(result, seconds: counter)
            .onReceive(timer) { _ in
                updateTime()
            }
    }
    
    private func updateTime() {
        guard running else { return }
        value = Date().timeIntervalSince(startTime)
        result = value.format(using: [.hour, .minute])
        counter = value.seconds()
    }
}

struct TimeCounter_Previews: PreviewProvider {
    static var previews: some View {
        let time = Date().timeIntervalSince(Date.now)
        TimeCounter(.constant(time), running: .constant(true))
    }
}
