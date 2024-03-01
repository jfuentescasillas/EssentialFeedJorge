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
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
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
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
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
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueImageFeed().locals
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedFeed(feed: feed, timestamp: timestamp)), file: file, line: line)
    }
    
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueImageFeed().locals
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .success(CachedFeed(feed: feed, timestamp: timestamp)), file: file, line: line)
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
        
        expect(sut, toRetrieve: .success(CachedFeed(feed: latestFeed, timestamp: latestTimestamp)), file: file, line: line)
    }
    
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: FeedStoreProtocol, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}


// MARK: - Extension. FeedStoreSpecsProtocol. Discardables & expect(_ sut...)
extension FeedStoreSpecsProtocol where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStoreProtocol) -> Error? {
        do {
            try sut.insert(cache.feed, timestamp: cache.timestamp)
            
            return nil
        } catch {
            return error
        }
    }
    
    
    @discardableResult
    func deleteCache(from sut: FeedStoreProtocol) -> Error? {
        do {
            try sut.deleteCachedFeed()
            return nil
        } catch {
            return error
        }
    }
    
    
    func expect(_ sut: FeedStoreProtocol, toRetrieve expectedResult: Result<CachedFeed?, Error>, file: StaticString = #file, line: UInt = #line) {
        let retrievedResult = Result { try sut.retrieve() }
        
        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
            (.failure, .failure):
            break
            
        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
            XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
            
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
    
    
    func expect(_ sut: FeedStoreProtocol, toRetrieveTwice expectedResult: Result<CachedFeed?, Error>, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
}
