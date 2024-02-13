//
//  FeedPresenterTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/10/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - FeedPresenterTests class
class FeedPresenterTests: XCTestCase {
    func test_tile_isLocalized() {
        XCTAssertEqual(FeedPresenter.title, localized("FEED_VIEW_TITLE"))
    }
    
    
    // MARK: - Helpers
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        
        return value
    }
}
