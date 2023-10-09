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
    
    
    func didStartLoadingFeed() {
        
    }
}


class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    func test_didStartLoadingFeed_displaysNoErrorMessage() {
//        let (_, view) = makeSUT()
        
//        XCTAssertEqual(view.messages, [.display(errorMessage: .none)])
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    
    private class ViewSpy {
        enum Message: Equatable {
            case display(errorMessage: String?)
        }
        
        let messages = [Message]()
    }
}
