//
//  BestTimesStoreTests.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import XCTest
@testable import QueenQuest

final class BestTimesStoreTests: XCTestCase {
    private var store: BestTimesStoreImpl!

    private var defaults: UserDefaults!
    private let suiteName: String = "BestTimesStoreTests"

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        store = BestTimesStoreImpl(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        store = nil
        super.tearDown()
    }

    func testWhenNoBestTimeValueIsSavedReturnsNil() {
        XCTAssertNil(store.bestTime(for: 8))
    }

    func testWhenBestTimeValueIsExactlyZeroReturnsNil() {
        defaults.set(0, forKey: "bestTimeSeconds_8")
        XCTAssertNil(store.bestTime(for: 8))
    }

    func testUpdateBestTimeAllowsSubOneSecondValues() {
        let didUpdate = store.updateBestTime(with: 0.25, for: 8)
        XCTAssertTrue(didUpdate)
        XCTAssertEqual(store.bestTime(for: 8), 0.25)
    }

    func testUpdateBestTimeFirstWriteReturnsTrueAndStoresValue() {
        let didUpdate = store.updateBestTime(with: 12, for: 8)
        XCTAssertTrue(didUpdate)
        XCTAssertEqual(store.bestTime(for: 8), 12)
    }

    func testUpdateBestTimeWhenNewTimeIsFasterReturnsTrueAndOverwrites() {
        _ = store.updateBestTime(with: 10, for: 8)
        let didUpdate = store.updateBestTime(with: 7, for: 8)
        XCTAssertTrue(didUpdate)
        XCTAssertEqual(store.bestTime(for: 8), 7)
    }

    func testUpdateBestTimeWhenNewTimeIsSlowerReturnsFalseAndDoesNotOverwrite() {
        _ = store.updateBestTime(with: 10, for: 8)
        let didUpdate = store.updateBestTime(with: 12, for: 8)
        XCTAssertFalse(didUpdate)
        XCTAssertEqual(store.bestTime(for: 8), 10)
    }

    func testUpdateBestTimeWhenNewTimeIsEqualReturnsFalseAndDoesNotOverwrite() {
        _ = store.updateBestTime(with: 10, for: 8)
        let didUpdate = store.updateBestTime(with: 10, for: 8)
        XCTAssertFalse(didUpdate)
        XCTAssertEqual(store.bestTime(for: 8), 10)
    }

    func testBestTimeIsIndependentPerBoardSize() {
        _ = store.updateBestTime(with: 10, for: 8)
        _ = store.updateBestTime(with: 5, for: 4)

        XCTAssertEqual(store.bestTime(for: 8), 10)
        XCTAssertEqual(store.bestTime(for: 4), 5)
    }
}
