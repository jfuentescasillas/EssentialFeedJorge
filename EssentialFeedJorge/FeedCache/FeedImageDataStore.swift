//
//  FeedImageDataStore.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 15/11/23.
//


import Foundation


// MARK: - FeedImageDataStoreProtocol
public protocol FeedImageDataStoreProtocol {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
