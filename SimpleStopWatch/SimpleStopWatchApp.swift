//
//  SimpleStopWatchApp.swift
//  SimpleStopWatch
//
//  Created by Ryan Stewart on 10/14/24.
//

import SwiftUI

@main
struct SimpleStopWatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 200, minHeight: 100)
        }
        .windowResizability(.contentSize)
    }
}
