//
//  QueenQuestView.swift
//  QueenQuest
//  
//  Created by Vander on 24/02/26.
//  

import SwiftUI

struct QueenQuestView: View {
    @StateObject private var viewModel = QueenQuestViewModel()
    @State private var showConfettiCelebrationView: Bool = false
    private static let confettiDuration: TimeInterval = 7.0

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Position \(viewModel.boardSize) queens that do not threaten each other.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                BoardControlsView(
                    boardSize: viewModel.boardSize,
                    onChangeSize: viewModel.setBoardSize(_:),
                    onRestart: viewModel.resetBoardState
                )

                BoardView(
                    boardSize: viewModel.boardSize,
                    queens: viewModel.queens,
                    conflicts: viewModel.conflicts,
                    onTap: handleBoardTap(_:)
                )

                GameStatusBarView(
                    isSolved: viewModel.isSolved,
                    startTime: viewModel.startTime,
                    elapsedTime: viewModel.elapsedTime,
                    bestSolvingTime: viewModel.bestSolvingTime,
                    boardSize: viewModel.boardSize,
                    queensCount: viewModel.queens.count,
                    conflictsCount: viewModel.conflicts.count
                )

                Spacer()
            }
            .navigationTitle("Queen Quest")
            .overlay(overlayLayer)
            .animation(.easeInOut, value: viewModel.isSolved)
            .onChange(of: viewModel.isSolved) { _, solved in
                if solved { handlePuzzleSolved() }
            }
        }
    }

    private func handleBoardTap(_ position: Position) {
        switch viewModel.toggleQueen(at: position) {
            case .placed: SFX.placeQueen()
            case .removed: SFX.removeQueen()
            case .ignored: break
        }
    }

    @ViewBuilder
    private var overlayLayer: some View {
        ConfettiCelebrationView(isActive: showConfettiCelebrationView).ignoresSafeArea()
        if viewModel.isSolved {
            PuzzleSolvedView(
                bestSolvingTime: viewModel.bestSolvingTime,
                didSetNewBestTime: viewModel.didSetNewBestTime,
                onPlayAgain: viewModel.resetBoardState
            )
        }
    }

    private func handlePuzzleSolved() {
        Celebration.win()
        showConfettiCelebrationView = true

        DispatchQueue.main.asyncAfter(deadline: .now() + Self.confettiDuration) {
            showConfettiCelebrationView = false
        }
    }
}

#Preview { QueenQuestView()}
