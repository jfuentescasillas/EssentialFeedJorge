//
//  ValidateFeedCacheUseCaseTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 21/08/23.
//


import XCTest
import EssentialFeedJorge


final class ValidateFeedCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMsgs, [])
    }
    
    
    // MARK: - Helper Methods
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
}
