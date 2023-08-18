//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 18/08/23.
//


import XCTest
import EssentialFeedJorge


final class LoadFeedFromCacheUseCaseTests: XCTestCase {
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
    
    
    // MARK: - Helper FeedStoreSpy Class
    private class FeedStoreSpy: FeedStoreProtocol {
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        private(set) var receivedMsgs = [ReceivedMsg]()
        
        
        enum ReceivedMsg: Equatable {
            case deleteCachedFile
            case insert([LocalFeedImage], Date)
        }
        
        
        func deleteCachedFeed(completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            receivedMsgs.append(.deleteCachedFile)
        }
        
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }
        
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
        
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMsgs.append(.insert(feed, timestamp))
        }
        
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }

        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }
}
