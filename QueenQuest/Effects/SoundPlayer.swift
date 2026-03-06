//
//  SoundPlayer.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//

import AudioToolbox

protocol SoundPlayer {
    func playPuzzleSolvedSound()
    func playQueenPlacedSound()
    func playQueenRemovedSound()
}

struct SoundPlayerImpl: SoundPlayer {
    func playPuzzleSolvedSound() { AudioServicesPlaySystemSound(1025) }
    func playQueenPlacedSound() { AudioServicesPlaySystemSound(1104) }
    func playQueenRemovedSound() { AudioServicesPlaySystemSound(1155) }
}
