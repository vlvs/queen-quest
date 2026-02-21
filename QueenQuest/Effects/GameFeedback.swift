//
//  GameFeedback.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//

import AudioToolbox
import UIKit

enum SystemSound {
    static let win: SystemSoundID = 1025
    static let placeQueen: SystemSoundID = 1104
    static let removeQueen: SystemSoundID = 1155
}

enum SFX {
    static func play(_ id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
    static func win() { play(SystemSound.win) }
    static func placeQueen() { play(SystemSound.placeQueen) }
    static func removeQueen() { play(SystemSound.removeQueen) }
}

enum Haptics {
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
}

enum Celebration {
    static func win() {
        Haptics.success()
        SFX.win()
    }
}
