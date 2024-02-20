//
//  NullStore.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 20/02/24.
//


import Foundation
import EssentialFeedJorge


class NullStore: FeedStoreProtocol & FeedImageDataStoreProtocol {
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(.success(()))
    }

    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }

    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(.none))
    }

    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        completion(.success(()))
    }

    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStoreProtocol.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
}
