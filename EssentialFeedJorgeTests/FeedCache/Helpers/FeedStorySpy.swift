//
//  FeedStorySpy.swift
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
    private(set) var receivedMsgs = [ReceivedMsg]()
    
    
    enum ReceivedMsg: Equatable {
        case deleteCachedFile
        case insert([LocalFeedImage], Date)
    }
    
    
    // MARK: Deletion Methods
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMsgs.append(.deleteCachedFile)
    }
    
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    
    // MARK: Insertion Methods
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
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
