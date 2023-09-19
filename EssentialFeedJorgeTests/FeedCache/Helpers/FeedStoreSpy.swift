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
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    private(set) var receivedMsgs = [ReceivedMsg]()
    
    
    enum ReceivedMsg: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    
    // MARK: Deletion Methods
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMsgs.append(.deleteCachedFeed)
    }
    
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    
    // MARK: Insertion Methods
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMsgs.append(.insert(feed, timestamp))
    }
    
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }

    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    
    // MARK: Retrieve Methods
    public func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMsgs.append(.retrieve)
    }
    
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success(.none))
    }
    
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.success(CachedFeed(feed: feed, timestamp: timestamp)))        
    }
}
