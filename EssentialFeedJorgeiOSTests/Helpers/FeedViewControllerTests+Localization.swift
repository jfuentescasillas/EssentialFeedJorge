//
//  FeedUIIntegrationTests+Localization.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 19/09/23.
//


import Foundation
import XCTest
import EssentialFeedJorgeiOS


extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        
        return value
    }
}
