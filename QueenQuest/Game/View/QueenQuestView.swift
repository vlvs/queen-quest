//
//  QueenQuestView.swift
//  QueenQuest
//  
//  Created by Vander on 24/02/26.
//  

import SwiftUI

struct QueenQuestView: View {
    @StateObject private var viewModel = QueenQuestViewModel()

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
                    onTap: viewModel.toggleQueen(at:)
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
        }
    }

    @ViewBuilder
    private var overlayLayer: some View {
        ConfettiCelebrationView(isActive: viewModel.isConfettiActive).ignoresSafeArea()
        if viewModel.isSolved {
            PuzzleSolvedView(
                bestSolvingTime: viewModel.bestSolvingTime,
                didSetNewBestTime: viewModel.didSetNewBestTime,
                onPlayAgain: viewModel.resetBoardState
            )
        }
    }
}

#Preview { QueenQuestView() }
