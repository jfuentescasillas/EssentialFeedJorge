//
//  InMemoryFeedStore.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 24/11/23.
//


import Foundation
import EssentialFeedJorge


// MARK: - InMemoryFeedStore
class InMemoryFeedStore {
    private(set) var feedCache: CachedFeed?
    private var feedImageDataCache: [URL: Data] = [:]
    
    
    private init(feedCache: CachedFeed? = nil) {
        self.feedCache = feedCache
    }
}
   
 
// MARK: - Extension. FeedStoreProtocol
extension InMemoryFeedStore: FeedStoreProtocol {
    func deleteCachedFeed(completion: @escaping FeedStoreProtocol.DeletionCompletion) {
        feedCache = nil
        completion(.success(()))
    }
    
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStoreProtocol.InsertionCompletion) {
        feedCache = CachedFeed(feed: feed, timestamp: timestamp)
        completion(.success(()))
    }
    
    
    func retrieve(completion: @escaping FeedStoreProtocol.RetrievalCompletion) {
        completion(.success(feedCache))
    }
}
   
 
// MARK: - Extension. FeedImageDataStoreProtocol
extension InMemoryFeedStore: FeedImageDataStoreProtocol {
    func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStoreProtocol.InsertionResult) -> Void) {
        feedImageDataCache[url] = data
        completion(.success(()))
    }
    
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStoreProtocol.RetrievalResult) -> Void) {
        completion(.success(feedImageDataCache[url]))
    }
}
   
 
// MARK: - Extension. Computed properties
extension InMemoryFeedStore {
    static var empty: InMemoryFeedStore {
       InMemoryFeedStore()
   }
   
   static var withExpiredFeedCache: InMemoryFeedStore {
       InMemoryFeedStore(feedCache: CachedFeed(feed: [], timestamp: Date.distantPast))
   }
   
   static var withNonExpiredFeedCache: InMemoryFeedStore {
       InMemoryFeedStore(feedCache: CachedFeed(feed: [], timestamp: Date()))
   }
}
