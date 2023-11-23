//
//  EssentialAppJorgeUIAcceptanceTests.swift
//  EssentialAppJorgeUIAcceptanceTests
//
//  Created by jfuentescasillas on 22/11/23.
//

import XCTest


final class EssentialAppJorgeUIAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        app.launch()

        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 22)
        
        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(firstImage.exists)
    }
    
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        
    }
}
