//
//  ContentView.swift
//  SimpleStopWatch
//
//  Created by Ryan Stewart on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    // stopwatch instance
    @ObservedObject var stopWatch = StopWatch()
    
    let myFont = Font
            .system(size: 24)
            .monospaced()
    
    var body: some View {
        VStack {
            // Timer display
            Text(stopWatch.stopWatchTime)
                .font(myFont)
            
            HStack {
                Button("Start") {
                    if self.stopWatch.paused {
                        self.stopWatch.start()
                    } else {
                        self.stopWatch.pause()
                    }
                }
                Button("Stop") {
                    if !self.stopWatch.paused {
                        self.stopWatch.pause()
                    }
                }
                Button("Reset") {
                    stopWatch.reset()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
