//
//  QueenQuestViewModel.swift
//  QueenQuest
//  
//  Created by Vander on 24/02/26.
//  

import Foundation
import Combine

@MainActor
final class QueenQuestViewModel: ObservableObject {
    @Published private(set) var boardSize: Int = 8
    @Published private(set) var queens: Set<Position> = []
    @Published private(set) var conflicts: Set<Position> = []
    @Published private(set) var isSolved: Bool = false
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var bestSolvingTime: TimeInterval? = nil
    @Published private(set) var didSetNewBestTime: Bool = false
    @Published private(set) var isConfettiActive: Bool = false

    private(set) var startTime: Date?

    private let clock: Clock
    private let bestTimesStore: BestTimesStore
    private let feedbackPlayer: GameFeedbackPlayer

    private var solvedCancellable: AnyCancellable?
    private var confettiTask: Task<Void, Never>?

    private static let confettiDuration: Duration = .seconds(7)

    init(
        boardSize: Int = 8,
        makeClock: @MainActor () -> Clock = { SystemClock() },
        makeBestTimesStore: @MainActor () -> BestTimesStore = { BestTimesStoreImpl() },
        makeFeedbackPlayer: @MainActor () -> GameFeedbackPlayer = {
            GameFeedbackPlayerImpl(
                haptics: HapticsPlayerImpl(),
                sounds: SoundPlayerImpl()
            )
        }
    ) {
        self.boardSize = max(4, boardSize)
        self.clock = makeClock()
        self.bestTimesStore = makeBestTimesStore()
        self.feedbackPlayer = makeFeedbackPlayer()

        loadBestSolvingTime()

        solvedCancellable = $isSolved
            .removeDuplicates()
            .filter { $0 }
            .sink { [weak self] _ in self?.handleSolvedPuzzle() }
    }

    deinit {
        confettiTask?.cancel()
    }

    func setBoardSize(_ n: Int) {
        let newSize = max(4, n)
        guard newSize != boardSize else { return }
        boardSize = newSize
        resetBoardState()
    }

    func resetBoardState() {
        confettiTask?.cancel()
        confettiTask = nil
        queens.removeAll()
        conflicts.removeAll()
        isSolved = false
        elapsedTime = 0
        startTime = nil
        didSetNewBestTime = false
        isConfettiActive = false

        loadBestSolvingTime()
    }

    func toggleQueen(at position: Position) {
        guard isWithinBounds(position) else { return }
        if startTime == nil { startTime = clock.now() }

        if queens.contains(position) {
            queens.remove(position)
            refreshBoardState()
            feedbackPlayer.queenRemoved()
        } else {
            guard queens.count < boardSize else { return }
            queens.insert(position)
            refreshBoardState()
            feedbackPlayer.queenPlaced()
        }
    }

    private func isWithinBounds(_ position: Position) -> Bool {
        (0..<boardSize).contains(position.row) && (0..<boardSize).contains(position.column)
    }

    private func refreshBoardState() {
        conflicts = computeConflictingQueens(from: queens)
        isSolved = (queens.count == boardSize && conflicts.isEmpty)
    }

    private func loadBestSolvingTime() {
        bestSolvingTime = bestTimesStore.bestTime(for: boardSize)
    }

    private func handleSolvedPuzzle() {
        if let startTime { elapsedTime = clock.now().timeIntervalSince(startTime) }
        didSetNewBestTime = bestTimesStore.updateBestTime(with: elapsedTime, for: boardSize)
        loadBestSolvingTime()

        feedbackPlayer.puzzleSolved()
        triggerConfetti(for: Self.confettiDuration)
    }

    private func triggerConfetti(for duration: Duration) {
        confettiTask?.cancel()
        isConfettiActive = true

        confettiTask = Task { [weak self] in
            try? await Task.sleep(for: duration)
            guard !Task.isCancelled else { return }
            self?.isConfettiActive = false
            self?.confettiTask = nil
        }
    }

    private func computeConflictingQueens(from queens: Set<Position>) -> Set<Position> {
        let list = Array(queens)
        var conflictSet: Set<Position> = []

        for i in 0..<list.count {
            for j in (i + 1)..<list.count {
                if threatens(list[i], list[j]) {
                    conflictSet.insert(list[i])
                    conflictSet.insert(list[j])
                }
            }
        }
        return conflictSet
    }

    private func threatens(_ queenA: Position, _ queenB: Position) -> Bool {
        if queenA.row == queenB.row { return true }
        if queenA.column == queenB.column { return true }
        if (queenA.row - queenA.column) == (queenB.row - queenB.column) { return true }
        if (queenA.row + queenA.column) == (queenB.row + queenB.column) { return true }
        return false
    }
}
