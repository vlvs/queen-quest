//
//  TimeFormatter.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import Foundation

enum TimeFormatter {
    static func format(_ time: TimeInterval) -> String {
        let total = Int(time)
        let minutes = total / 60
        let seconds = total % 60

        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            let unit = (seconds == 1) ? "second" : "seconds"
            return "\(seconds) \(unit)"
        }
    }
}
