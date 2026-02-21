//
//  GameStatusBarView.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import SwiftUI

struct GameStatusBarView: View {
    let isSolved: Bool

    let startTime: Date?
    let elapsedTime: TimeInterval
    let bestSolvingTime: TimeInterval?

    let boardSize: Int
    let queensCount: Int
    let conflictsCount: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                TimeLabelView(
                    isSolved: isSolved,
                    startTime: startTime,
                    elapsedTime: elapsedTime
                )

                if let bestSolvingTime {
                    Text("Best Time: \(TimeFormatter.format(bestSolvingTime))")
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("Queens: \(queensCount)/\(boardSize)")
                Text("Conflicts: \(conflictsCount)")
            }
        }
        .font(.subheadline)
        .padding(.horizontal)
    }
}
