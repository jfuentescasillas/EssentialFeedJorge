//
//  FeedEndpointTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 10/02/24.
//


import XCTest
import EssentialFeedJorge


class FeedEndpointTests: XCTestCase {
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = FeedEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/feed")!
        
        XCTAssertEqual(received, expected)
    }
    
}
