//
//  WinOverlay.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import SwiftUI

struct PuzzleSolvedView: View {
    let bestSolvingTime: TimeInterval?
    let didSetNewBestTime: Bool
    var onPlayAgain: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()

            VStack(spacing: 12) {
                Text("You solved it!")
                    .font(.title2).bold()

                Text("All queens are safely placed.")
                    .foregroundStyle(.secondary)

                if let bestSolvingTime {
                    let isRecord = didSetNewBestTime
                    let formattedBestSolvingTime = TimeFormatter.format(bestSolvingTime)
                    Text("\(isRecord ? "New record" : "Best time"): \(formattedBestSolvingTime)!")
                        .font(isRecord ? .subheadline.bold() : .subheadline)
                        .foregroundStyle(isRecord ? .primary : .secondary)
                }

                Button("Play again", action: onPlayAgain)
                    .buttonSizing(.fitted)
                    .accessibilityIdentifier("PlayAgainButton")
            }
            .padding(20)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(24)
            .accessibilityElement(children: .contain)
        }
        .accessibilityIdentifier("PuzzleSolvedView")
    }
}
