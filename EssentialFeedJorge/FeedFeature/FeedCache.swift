//
//  FeedCache.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 20/11/23.
//


import Foundation


// MARK: - Protocol
public protocol FeedCacheProtocol {
    func save(_ feed: [FeedImage]) throws
}
