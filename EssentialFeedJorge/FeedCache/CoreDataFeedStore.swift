//
//  CoreDataFeedStore.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 28/08/23.
//


import Foundation


public final class CoreDataFeedStore: FeedStoreProtocol {
    public init() {}
    
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
}
