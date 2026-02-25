//
//  Clock.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import Foundation

protocol Clock {
    func now() -> Date
}

struct SystemClock: Clock {
    func now() -> Date { Date() }
}
