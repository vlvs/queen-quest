//
//  GameFeedbackPlayer.swift
//  QueenQuest
//  
//  Created by Vander on 06/03/26.
//  

protocol GameFeedbackPlayer {
    func puzzleSolved()
    func queenPlaced()
    func queenRemoved()
}

struct GameFeedbackPlayerImpl: GameFeedbackPlayer {
    let haptics: HapticsPlayer
    let sounds: SoundPlayer

    func puzzleSolved() {
        haptics.playPuzzleSolvedHaptics()
        sounds.playPuzzleSolvedSound()
    }

    func queenPlaced() {
        sounds.playQueenPlacedSound()
    }

    func queenRemoved() {
        sounds.playQueenRemovedSound()
    }
}
