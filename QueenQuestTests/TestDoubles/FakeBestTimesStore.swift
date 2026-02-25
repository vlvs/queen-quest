//
//  FakeBestTimesStore.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import Foundation
@testable import QueenQuest

final class FakeBestTimesStore: BestTimesStore {
    private var values: [Int: TimeInterval] = [:]

    func bestTime(for boardSize: Int) -> TimeInterval? {
        values[boardSize]
    }

    func updateBestTime(with newTime: TimeInterval, for boardSize: Int) -> Bool {
        if let currentTime = values[boardSize], currentTime <= newTime { return false }
        values[boardSize] = newTime
        return true
    }

    func seedBestTime(_ time: TimeInterval, boardSize: Int) {
        values[boardSize] = time
    }
}
