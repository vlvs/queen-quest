//
//  QueenQuestUITests.swift
//  QueenQuestUITests
//  
//  Created by Vander on 21/02/26.
//  

import XCTest

final class QueenQuestUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSolving4x4ShowsSolvedOverlayAndPlayAgainResets() {
        selectBoardSize(4)
        assertQueensCountEquals("0/4")
        solvePuzzleFor4x4Board()
        assertQueensCountEquals("4/4")
        assertPuzzleSolvedViewIsVisible()
        playAgainButton.tap()
        assertPuzzleSolvedViewIsNotVisible()
        assertQueensCountEquals("0/4")
    }
}

// MARK: - Screen Elements

private extension QueenQuestUITests {
    var sizePicker: XCUIElement { app.buttons["BoardSizePicker"].firstMatch }
    var queensCountLabel: XCUIElement { app.staticTexts["QueensCountLabel"].firstMatch }
    var puzzleSolvedView: XCUIElement { app.otherElements["PuzzleSolvedView"].firstMatch }
    var playAgainButton: XCUIElement { app.buttons["PlayAgainButton"].firstMatch }
}

// MARK: - Actions

private extension QueenQuestUITests {
    func selectBoardSize(_ size: Int) {
        XCTAssertTrue(sizePicker.waitForExistence(timeout: 3))
        sizePicker.tap()

        let boardOption = app.buttons["BoardSizeOption_\(size)"].firstMatch
        XCTAssertTrue(boardOption.waitForExistence(timeout: 3), "Missing BoardSizeOption_\(size)")
        boardOption.tap()
    }

    func solvePuzzleFor4x4Board() {
        tapCell(at: 0, 1)
        tapCell(at: 1, 3)
        tapCell(at: 2, 0)
        tapCell(at: 3, 2)
    }

    private func tapCell(at row: Int, _ column: Int) {
        let cell = app.otherElements["Cell(\(row), \(column))"].firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 1), "Missing Cell(\(row), \(column))")
        cell.tap()
    }
}

// MARK: - Assertions

private extension QueenQuestUITests {
    func assertQueensCountEquals(_ expected: String, timeout: TimeInterval = 3) {
        XCTAssertTrue(queensCountLabel.waitForExistence(timeout: timeout))
        waitForLabel(queensCountLabel, toContain: expected, timeout: timeout)
    }

    func assertPuzzleSolvedViewIsVisible() {
        XCTAssertTrue(puzzleSolvedView.waitForExistence(timeout: 3))
    }

    func assertPuzzleSolvedViewIsNotVisible() {
        XCTAssertFalse(puzzleSolvedView.exists)
    }

    private func waitForLabel(
        _ element: XCUIElement,
        toContain substring: String,
        timeout: TimeInterval) {
            let predicate = NSPredicate(format: "label CONTAINS %@", substring)
            let expectation = expectation(for: predicate, evaluatedWith: element)
            wait(for: [expectation], timeout: timeout)
    }
}
