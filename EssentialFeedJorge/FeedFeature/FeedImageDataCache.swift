//
//  FeedImageDataCache.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 21/11/23.
//


import Foundation


// MARK: - FeedImageDataCacheProtocol
public protocol FeedImageDataCacheProtocol {
    typealias Result = Swift.Result<Void, Error>
    
    
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
