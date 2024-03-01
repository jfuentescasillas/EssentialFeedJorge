//
//  FeedStoreProtocol.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 17/08/23.
//


import Foundation


public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)


// MARK: - FeedStoreProtocol
public protocol FeedStoreProtocol {
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
