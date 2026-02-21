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

    override func setUp() {
        super.setUp()
        viewModel = QueenQuestViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

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

    private func placeQueen(at row: Int, _ column: Int) {
        let result = viewModel.toggleQueen(at: Position(row: row, column: column))
        XCTAssertEqual(result, .placed, "Expected to place queen at (\(row), \(column)")
    }

    private func removeQueen(at row: Int, _ column: Int) {
        let result = viewModel.toggleQueen(at: Position(row: row, column: column))
        XCTAssertEqual(result, .removed, "Expected to remove queen at (\(row), \(column)")
    }

    private func assertConflicts(_ expected: Set<Position>) {
        XCTAssertEqual(viewModel.conflicts, expected)
    }
}
