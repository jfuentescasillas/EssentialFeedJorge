//
//  FeedStoreSpy.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 18/08/23.
//


import Foundation
import EssentialFeedJorge


// MARK: - Helper FeedStoreSpy Class
public class FeedStoreSpy: FeedStoreProtocol {
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedFeed?, Error>?
    private(set) var receivedMsgs = [ReceivedMsg]()
    
    
    enum ReceivedMsg: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    
    // MARK: Deletion Methods
    public func deleteCachedFeed() throws {
        receivedMsgs.append(.deleteCachedFeed)
        
        try deletionResult?.get()
    }
    
    
    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }
    
    
    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }
    
    
    // MARK: Insertion Methods
    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        receivedMsgs.append(.insert(feed, timestamp))
        
        try insertionResult?.get()
    }
    
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }

    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    
    // MARK: Retrieve Methods
    public func retrieve() throws -> CachedFeed? {
        receivedMsgs.append(.retrieve)
        
        return try retrievalResult?.get()
    }
    
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    
    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }
    
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date) {
        retrievalResult = .success(CachedFeed(feed: feed, timestamp: timestamp))
    }
}
