//
//  FeedImageDataCache.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 21/11/23.
//


import Foundation


// MARK: - FeedImageDataCacheProtocol
public protocol FeedImageDataCacheProtocol {
    func save(_ data: Data, for url: URL) throws
}
