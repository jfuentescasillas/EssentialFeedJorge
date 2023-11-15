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
        perform { context in
            completion(Result {
                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            })
        }
    }
    
    
    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStoreProtocol.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedFeedImage.first(with: url, in: context)?.data
            })
        }
    }
}
