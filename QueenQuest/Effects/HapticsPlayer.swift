//
//  HapticsPlayer.swift
//  QueenQuest
//  
//  Created by Vander on 06/03/26.
//  

import UIKit

protocol HapticsPlayer {
    func playPuzzleSolvedHaptics()
}

struct HapticsPlayerImpl: HapticsPlayer {
    func playPuzzleSolvedHaptics() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
}
