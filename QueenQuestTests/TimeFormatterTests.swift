//
//  TimeFormatterTests.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import XCTest
@testable import QueenQuest

final class TimeFormatterTests: XCTestCase {
    func testFormatWhenZeroSecondsReturnsPluralSecondsUbit() {
        XCTAssertEqual(TimeFormatter.format(0), "0 seconds")
    }

    func testFormatWhenOneSecondsReturnsSingularSecondsUnit() {
        XCTAssertEqual(TimeFormatter.format(1), "1 second")
    }

    func testFormatWhenTwoSecondsReturnsPluralSecondsUnit() {
        XCTAssertEqual(TimeFormatter.format(2), "2 seconds")
    }

    func testFormatWhenFiftyNineSecondsReturnsSecondsUnit() {
        XCTAssertEqual(TimeFormatter.format(59), "59 seconds")
    }

    func testFormatWhenSixtySecondsReturnsOneMinuteWithTwoDigitSeconds() {
         XCTAssertEqual(TimeFormatter.format(60), "1:00")
     }

    func testFormatWhenOneHundredTwentyFiveSecondsReturnsTwoMinutesFiveSeconds() {
        XCTAssertEqual(TimeFormatter.format(125), "2:05")
    }

    func testFormatWhenTenMinutesReturnsTenMinutesZeroSeconds() {
        XCTAssertEqual(TimeFormatter.format(600), "10:00")
    }

    func testFormatRoundsDownForFractionalSeconds() {
        XCTAssertEqual(TimeFormatter.format(1.9), "1 second")
        XCTAssertEqual(TimeFormatter.format(59.99), "59 seconds")
        XCTAssertEqual(TimeFormatter.format(60.99), "1:00")
    }
}
