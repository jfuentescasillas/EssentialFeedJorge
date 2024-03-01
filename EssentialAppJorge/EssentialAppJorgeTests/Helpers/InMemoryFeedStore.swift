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
    func deleteCachedFeed() throws {
        feedCache = nil
    }
    
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        feedCache = CachedFeed(feed: feed, timestamp: timestamp)
    }
    
    
    func retrieve() throws -> CachedFeed? {
        return feedCache
    }
}
   
 
// MARK: - Extension. FeedImageDataStoreProtocol
extension InMemoryFeedStore: FeedImageDataStoreProtocol {
    func insert(_ data: Data, for url: URL) {
        feedImageDataCache[url] = data
    }
    
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        return feedImageDataCache[url]
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
