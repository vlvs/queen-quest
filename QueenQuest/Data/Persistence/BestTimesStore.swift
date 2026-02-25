//
//  BestTimesStore.swift
//  QueenQuest
//  
//  Created by Vander on 24/02/26.
//  

import Foundation

protocol BestTimesStore {
    func bestTime(for boardSize: Int) -> TimeInterval?
    func updateBestTime(with newTime: TimeInterval, for boardSize: Int) -> Bool
}

final class BestTimesStoreImpl: BestTimesStore {
    private let defaults: UserDefaults
    private let keyPrefix: String = "bestTimeSeconds_"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func bestTime(for boardSize: Int) -> TimeInterval? {
        let key = keyPrefix + String(boardSize)
        let value = defaults.double(forKey: key)
        return value > 0 ? value : nil
    }

    func updateBestTime(with newTime: TimeInterval, for boardSize: Int) -> Bool {
        let key = keyPrefix + String(boardSize)
        if let currentTime = bestTime(for: boardSize), currentTime <= newTime {
            return false
        }
        defaults.set(newTime, forKey: key)
        return true
    }
}
