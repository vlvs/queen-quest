//
//  Position.swift
//  QueenQuest
//  
//  Created by Vander on 24/02/26.
//  

struct Position: Hashable, Identifiable {
    let row: Int
    let column: Int

    var id: String { "\(row)-\(column)" }
}
