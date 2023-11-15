//
//  LocalFeedImageDataLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 15/11/23.
//


import Foundation


// MARK: - Class LocalFeedImageDataLoader
public final class LocalFeedImageDataLoader: FeedImageDataLoaderProtocol {
    private let store: FeedImageDataStoreProtocol
    
    
    public init(store: FeedImageDataStoreProtocol) {
        self.store = store
    }
    
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    
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
    
    
    public typealias SaveResult = Result<Void, Swift.Error>
    
    
    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { _ in }
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


