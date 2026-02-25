//
//  TestClock.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import Foundation
@testable import QueenQuest

final class TestClock: Clock {
    var date: Date
    init(date: Date) { self.date = date }
    func now() -> Date { date }
}
