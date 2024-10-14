//
//  StopWatch.swift
//  SimpleStopWatch
//
//  Created by Ryan Stewart on 10/14/24.
//


//
//  StopWatch.swift
//  StopWatch
//
//  Created by ProgrammingWithSwift on 2020/05/24.
//  Copyright © 2020 ProgrammingWithSwift. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class StopWatch: ObservableObject {
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "stopwatch.timer")
    private var counter: Int = 0
    
    var stopWatchTime = "00:00:00:00" {
        didSet {
            self.update()
        }
    }
    
    var paused = true {
        didSet {
            self.update()
        }
    }
    
    var laps = [LapItem]() {
        didSet {
            self.update()
        }
    }
    
    private var currentLaps = [LapItem]() {
        didSet {
            self.laps = currentLaps.reversed()
        }
    }
    
    func start() {
        self.paused = !self.paused
        
        guard let _ = self.sourceTimer else {
            self.startTimer()
            return
        }
        
        self.resumeTimer()
    }
    
    func pause() {
        self.paused = !self.paused
        self.sourceTimer?.suspend()
    }
    
    func lap() {
        if let firstLap = self.laps.first {
            let difference = self.counter - firstLap.count
            self.currentLaps.append(LapItem(count: self.counter, diff: difference))
        } else {
            self.currentLaps.append(LapItem(count: self.counter))
        }
    }
    
    func reset() {
        self.stopWatchTime = "00:00:00:00"
        self.counter = 0
        self.currentLaps = [LapItem]()
    }
    
    func update() {
        objectWillChange.send()
    }
    
    func isPaused() -> Bool {
        return self.paused
    }
    
    private func startTimer() {
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                          queue: self.queue)
        
        self.resumeTimer()
    }
    
    private func resumeTimer() {
        self.sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        self.sourceTimer?.schedule(deadline: .now(),
                                   repeating: 0.01)
        self.sourceTimer?.resume()
    }
    
    private func updateTimer() {
        self.counter += 1
        
        DispatchQueue.main.async {
            self.stopWatchTime = StopWatch.convertCountToTimeString(counter: self.counter)
        }
    }
}

extension StopWatch {
    struct LapItem {
        let uuid = UUID()
        let count: Int
        let stringTime: String
        
        init(count: Int, diff: Int = -1) {
            self.count = count
            
            if diff < 0 {
                self.stringTime = StopWatch.convertCountToTimeString(counter: count)
            } else {
                self.stringTime = StopWatch.convertCountToTimeString(counter: diff)
            }
        }
    }
}

extension StopWatch {
    static func convertCountToTimeString(counter: Int) -> String {
        let milliseconds = counter % 100
        let seconds = (counter / 100) % 60
        let minutes = (counter / (100 * 60)) % 60
        let hours = (counter / (100 * 60 * 60))
        
        return String(format: "%02d:%02d:%02d:%02d", hours, minutes, seconds, milliseconds)
    }
}
