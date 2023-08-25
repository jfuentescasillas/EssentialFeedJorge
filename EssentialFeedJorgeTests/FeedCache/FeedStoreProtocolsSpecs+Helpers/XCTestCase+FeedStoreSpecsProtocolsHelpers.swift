//
//  XCTestCase+FeedStoreSpecsProtocolsHelpers.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 25/08/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - Extension. FailableDeleteFeedStoreSpecsProtocol. Assertions
extension FailableDeleteFeedStoreSpecsProtocol where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }
    
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}


// MARK: - Extension. FailableInsertFeedStoreSpecsProtocol. Assertions
extension FailableInsertFeedStoreSpecsProtocol where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().locals, Date()), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)
        
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}


// MARK: - Extension. FailableRetrieveFeedStoreSpecsProtocol. Assertions
extension FailableRetrieveFeedStoreSpecsProtocol where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}


// MARK: - Extension. FeedStoreSpecsProtocol. Assertions
extension FeedStoreSpecsProtocol where Self: XCTestCase {
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
    
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .empty, file: file, line: line)
    }
    
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueImageFeed().locals
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp), file: file, line: line)
    }
    
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueImageFeed().locals
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp), file: file, line: line)
    }
    
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().locals, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)
        
        let insertionError = insert((uniqueImageFeed().locals, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }
    
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)
        
        let latestFeed = uniqueImageFeed().locals
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp), file: file, line: line)
    }
    
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
    
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
    
    
    func assertThatSideEffectsRunSerially(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueImageFeed().locals, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueImageFeed().locals, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order", file: file, line: line)
    }
}


// MARK: - Extension. FeedStoreSpecsProtocol. Discardables & expect(_ sut...)
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
