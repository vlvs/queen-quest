//
//  TimeLabelView.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import SwiftUI

struct TimeLabelView: View {
    let isSolved: Bool
    let startTime: Date?
    let elapsedTime: TimeInterval

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { _ in
            Text("Time: \(TimeFormatter.format(currentTime))").monospacedDigit()
        }
    }

    private var currentTime: TimeInterval {
        if isSolved { return elapsedTime }
        if let startTime { return Date().timeIntervalSince(startTime) }
        return 0
    }
}
