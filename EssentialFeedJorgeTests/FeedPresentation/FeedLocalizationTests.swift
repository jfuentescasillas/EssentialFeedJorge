//
//  FeedLocalizationTests.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 20/09/23.
//


import XCTest
import EssentialFeedJorge


final class FeedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
