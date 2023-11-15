//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 15/11/23.
//


import Foundation
import EssentialFeedJorge


class FeedImageDataStoreSpy: FeedImageDataStoreProtocol {
    enum Message: Equatable {
        case insert(data: Data, for: URL)
        case retrieve(dataFor: URL)
    }
    
    
    private var retrievalCompletions = [(FeedImageDataStoreProtocol.RetrievalResult) -> Void]()
    private(set) var receivedMessages = [Message]()
    
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
    }
    
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStoreProtocol.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }
    
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
}
