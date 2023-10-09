//
//  FeedPresenterTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/10/23.
//


import XCTest


final class FeedPresenter {
    init(view: Any) {
        
    }
}


class FeedPresenterTests: XCTestCase {
    func test_ini_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    // MARK: - Helpers
    private class ViewSpy {
        let messages = [Any]()
    }
}
