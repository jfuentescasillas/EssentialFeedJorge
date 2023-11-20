//
//  FeedCache.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 20/11/23.
//


import Foundation


// MARK: - Protocol
public protocol FeedCacheProtocol {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
