//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 15/11/23.
//


import Foundation


// MARK: - Extension. CoreDataFeedStore: FeedImageDataStoreProtocol
extension CoreDataFeedStore: FeedImageDataStoreProtocol {
    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStoreProtocol.InsertionResult) -> Void) {
        
    }
    
    
    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStoreProtocol.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
}
