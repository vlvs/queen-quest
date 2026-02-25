//
//  QueenQuestViewModelTests.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import XCTest
@testable import QueenQuest

@MainActor
final class QueenQuestViewModelTests: XCTestCase {
    private var viewModel: QueenQuestViewModel!

    private var clock: TestClock!
    private var store: FakeBestTimesStore!

    override func setUp() {
        super.setUp()
        clock = TestClock(date: Date(timeIntervalSince1970: 0))
        store = FakeBestTimesStore()

        viewModel = QueenQuestViewModel(
            boardSize: 8,
            makeClock: { self.clock },
            makeBestTimesStore: { self.store }
        )
    }

    override func tearDown() {
        viewModel = nil
        clock = nil
        store = nil
        super.tearDown()
    }

    func testPlacingQueenIncrementsQueensCount() {
        XCTAssertEqual(viewModel.queens.count, 0)
        placeQueen(at: 0, 0)
        XCTAssertEqual(viewModel.queens.count, 1)
    }

    func testTappingCellWithQueenRemovesQueen() {
        placeQueen(at: 4, 4)
        XCTAssertEqual(viewModel.queens.count, 1)

        removeQueen(at: 4, 4)
        XCTAssertEqual(viewModel.queens.count, 0)
    }

    func testCannotPlaceMoreQueensThanBoardSize() {
        for row in 0..<8 { placeQueen(at: row, 0) }
        XCTAssertEqual(viewModel.queens.count, 8)

        let result = viewModel.toggleQueen(at: Position(row: 0, column: 1))
        XCTAssertEqual(result, .ignored)
        XCTAssertEqual(viewModel.queens.count, 8)
    }

    func testOutOfBoundsTapIsIgnoredAndDoesNotChangeQueensCount() {
        let result = viewModel.toggleQueen(at: Position(row: 99, column: 99))
        XCTAssertEqual(result, .ignored)
        XCTAssertEqual(viewModel.queens.count, 0)
    }

    func testSolvingPuzzleSetsIsSolvedFlagAndHasNoConflicts() {
        solvePuzzleFor8x8BoardSize()
        XCTAssertTrue(viewModel.isSolved)
        XCTAssertEqual(viewModel.queens.count, 8)
        XCTAssertEqual(viewModel.conflicts.count, 0)
    }

    // MARK: Time Management

    func testFirstQueenPlacementStartsTimer() {
        XCTAssertNil(viewModel.startTime)
        placeQueen(at: 2, 2)
        XCTAssertNotNil(viewModel.startTime)
    }

    func testSolvingFirstTimeSetsBestTimeAndNewBestTimeFlagIsTrue() {
        solvePuzzleFor8x8BoardSize(in: 12)
        XCTAssertTrue(viewModel.isSolved)
        XCTAssertEqual(viewModel.elapsedTime, 12)
        XCTAssertEqual(viewModel.bestSolvingTime, 12)
        XCTAssertTrue(viewModel.didSetNewBestTime)
    }

    func testSolvingSlowerThanBestTimeDoesNotOverwriteAndNewBestTimeFlagIsFalse() {
        store.seedBestTime(10, boardSize: 8)
        viewModel.resetBoardState()
        XCTAssertEqual(viewModel.bestSolvingTime, 10)

        solvePuzzleFor8x8BoardSize(in: 15)
        XCTAssertTrue(viewModel.isSolved)
        XCTAssertEqual(viewModel.elapsedTime, 15)
        XCTAssertEqual(viewModel.bestSolvingTime, 10)
        XCTAssertFalse(viewModel.didSetNewBestTime)
    }

    func testSolvingFasterThanBestTimeOverwritesAndFlagNewBestTimeIsTrue() {
        store.seedBestTime(20, boardSize: 8)
        viewModel.resetBoardState()
        XCTAssertEqual(viewModel.bestSolvingTime, 20)

        solvePuzzleFor8x8BoardSize(in: 7)
        XCTAssertTrue(viewModel.isSolved)
        XCTAssertEqual(viewModel.elapsedTime, 7)
        XCTAssertEqual(viewModel.bestSolvingTime, 7)
        XCTAssertTrue(viewModel.didSetNewBestTime)
    }

    func testResetClearsSessionStateButKeepsBestTimeLoaded() {
        store.seedBestTime(9, boardSize: 8)
        viewModel.resetBoardState()
        XCTAssertEqual(viewModel.bestSolvingTime, 9)

        placeQueen(at: 0, 0)
        XCTAssertNotNil(viewModel.startTime)

        viewModel.resetBoardState()
        XCTAssertNil(viewModel.startTime)
        XCTAssertEqual(viewModel.elapsedTime, 0)
        XCTAssertEqual(viewModel.bestSolvingTime, 9)
        XCTAssertFalse(viewModel.didSetNewBestTime)
    }

    // MARK: - Queen Conflicts

    func testConflictsInTheSameRowMarksBothQueens() {
        placeQueen(at: 0, 0)
        placeQueen(at: 0, 3)

        assertConflicts([
            Position(row: 0, column: 0),
            Position(row: 0, column: 3)
        ])
    }

    func testManyConflictsInTheSameRowMarksAllQueens() {
        placeQueen(at: 4, 1)
        placeQueen(at: 4, 3)
        placeQueen(at: 4, 4)

        assertConflicts([
            Position(row: 4, column: 1),
            Position(row: 4, column: 3),
            Position(row: 4, column: 4)
        ])
    }

    func testConflictsInTheSameColumnMarksBothQueens() {
        placeQueen(at: 1, 2)
        placeQueen(at: 4, 2)

        assertConflicts([
            Position(row: 1, column: 2),
            Position(row: 4, column: 2)
        ])
    }

    func testManyConflictsInTheSameColumnMarksAllQueens() {
        placeQueen(at: 0, 6)
        placeQueen(at: 2, 6)
        placeQueen(at: 3, 6)
        placeQueen(at: 4, 6)

        assertConflicts([
            Position(row: 0, column: 6),
            Position(row: 2, column: 6),
            Position(row: 3, column: 6),
            Position(row: 4, column: 6)
        ])
    }

    func testConflictsInTheSameDiagonalMarksBothQueens() {
        placeQueen(at: 0, 0)
        placeQueen(at: 3, 3)

        assertConflicts([
            Position(row: 0, column: 0),
            Position(row: 3, column: 3)
        ])
    }

    func testManyConflictsInTheSameDiagonalMarksAllQueens() {
        placeQueen(at: 0, 0)
        placeQueen(at: 2, 2)
        placeQueen(at: 3, 3)
        placeQueen(at: 5, 5)
        placeQueen(at: 7, 7)

        assertConflicts([
            Position(row: 0, column: 0),
            Position(row: 2, column: 2),
            Position(row: 3, column: 3),
            Position(row: 5, column: 5),
            Position(row: 7, column: 7),
        ])
    }

    func testConflictsInTheSameAntidiagonalMarksBothQueens() {
        placeQueen(at: 0, 2)
        placeQueen(at: 4, 6)

        assertConflicts([
            Position(row: 0, column: 2),
            Position(row: 4, column: 6)
        ])
    }

    func testManyConflictsInTheSameAntidiagonalMarksAllQueens() {
        placeQueen(at: 0, 1)
        placeQueen(at: 1, 2)
        placeQueen(at: 3, 4)
        placeQueen(at: 4, 5)
        placeQueen(at: 5, 6)
        placeQueen(at: 6, 7)

        assertConflicts([
            Position(row: 0, column: 1),
            Position(row: 1, column: 2),
            Position(row: 3, column: 4),
            Position(row: 4, column: 5),
            Position(row: 5, column: 6),
            Position(row: 6, column: 7)
        ])
    }

    func testNoConflictsWhenNoThreatenedQueens() {
        placeQueen(at: 0, 0)
        placeQueen(at: 1, 2)
        placeQueen(at: 4, 7)
        placeQueen(at: 5, 4)

        assertConflicts([])
    }

    func testOnlyThreatenedQueensCountAsConflicts() {
        placeQueen(at: 2, 2)
        placeQueen(at: 0, 6)
        placeQueen(at: 2, 7)

        assertConflicts([
            Position(row: 2, column: 2),
            Position(row: 2, column: 7)
        ])
    }

    func testRemovingQueenRecomputesConflictsToEmpty() {
        placeQueen(at: 4, 4)
        placeQueen(at: 4, 7)
        XCTAssertFalse(viewModel.conflicts.isEmpty)

        removeQueen(at: 4, 4)
        assertConflicts([])
    }

    // MARK: - Helpers

    private func solvePuzzleFor8x8BoardSize(in time: TimeInterval? = nil) {
        placeQueen(at: 0, 5)
        placeQueen(at: 1, 3)
        placeQueen(at: 2, 6)
        placeQueen(at: 3, 0)
        placeQueen(at: 4, 7)
        placeQueen(at: 5, 1)
        placeQueen(at: 6, 4)

        if let time { clock.date = Date(timeIntervalSince1970: time) }
        placeQueen(at: 7, 2)
    }

    private func placeQueen(at row: Int, _ column: Int) {
        let result = viewModel.toggleQueen(at: Position(row: row, column: column))
        XCTAssertEqual(result, .placed, "Expected to place queen at (\(row), \(column))")
    }

    private func removeQueen(at row: Int, _ column: Int) {
        let result = viewModel.toggleQueen(at: Position(row: row, column: column))
        XCTAssertEqual(result, .removed, "Expected to remove queen at (\(row), \(column))")
    }

    private func assertConflicts(_ expected: Set<Position>) {
        XCTAssertEqual(viewModel.conflicts, expected)
    }
}
