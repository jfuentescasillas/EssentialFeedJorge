//
//  XCTestCase+FeedStoreSpecsProtocol.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 25/08/23.
//


import XCTest
import EssentialFeedJorge


extension FeedStoreSpecsProtocol where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStoreProtocol) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        
        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        return insertionError
    }
    
    
    @discardableResult
    func deleteCache(from sut: FeedStoreProtocol) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        
        sut.deleteCachedFeed { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 4)
        
        return deletionError
    }
    
    
    func expect(_ sut: FeedStoreProtocol, toRetrieve expectedResult: RetrievedCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation (description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
                
            case let (.found(expectedFeed, expectedTimestamp), .found(retrievedFeed, retrievedTimestamp)):
                XCTAssertEqual(retrievedFeed, expectedFeed, file: file, line: line)
                XCTAssertEqual(retrievedTimestamp, expectedTimestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead",
                        file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func expect(_ sut: FeedStoreProtocol, toRetrieveTwice expectedResult: RetrievedCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
}
