//
//  FeedStoreProtocol.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 17/08/23.
//


import Foundation


public enum RetrievedCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}


// MARK: - FeedStoreProtocol
public protocol FeedStoreProtocol {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrievedCachedFeedResult) -> Void

    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
