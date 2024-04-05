//
//  NullStore.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 20/02/24.
//


import Foundation
import EssentialFeedJorge


class NullStore: FeedStoreProtocol {
    func deleteCachedFeed() throws {}
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {}
    func retrieve() throws -> CachedFeed? { .none }
}


// MARK: - Extension. FeedImageDataStoreProtocol
extension NullStore: FeedImageDataStoreProtocol {
    func insert(_ data: Data, for url: URL) throws {}

    
    func retrieve(dataForURL url: URL) throws -> Data? { .none }
}
