//
//  LocalFeedImageDataLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 15/11/23.
//


import Foundation


// MARK: - Class LocalFeedImageDataLoader
public final class LocalFeedImageDataLoader: FeedImageDataLoaderProtocol {
    private final class Task: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoaderProtocol.Result) -> Void)?
        
        
        init(_ completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) {
            self.completion = completion
        }
        
        
        func complete(with result: FeedImageDataLoaderProtocol.Result) {
            completion?(result)
        }
        
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    
    private let store: FeedImageDataStoreProtocol
    
    
    public init(store: FeedImageDataStoreProtocol) {
        self.store = store
    }
    
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError {_ in Error.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(Error.notFound)
                })
        }
        
        return task
    }
}


