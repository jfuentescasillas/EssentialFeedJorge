//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 14/11/23.
//


import XCTest
import EssentialFeedJorge


final class LocalFeedImageDataLoader {
    init(store: Any) {
        
    }
}


// MARK: - Class LocalFeedImageDataLoaderTests
class LocalFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
      
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    
    private class FeedStoreSpy {
        let receivedMessages = [Any]()
    }
}
