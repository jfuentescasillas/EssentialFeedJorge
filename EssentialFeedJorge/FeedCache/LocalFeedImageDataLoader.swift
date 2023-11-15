//
//  LocalFeedImageDataLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 15/11/23.
//


import Foundation


// MARK: - Class LocalFeedImageDataLoader
public final class LocalFeedImageDataLoader {
    private let store: FeedImageDataStoreProtocol
    
    
    public init(store: FeedImageDataStoreProtocol) {
        self.store = store
    }
}


// MARK: - Extension. LocalFeedImageDataLoader
extension LocalFeedImageDataLoader {
    public typealias SaveResult = Result<Void, Error>
    
    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { _ in }
    }
}


// MARK: - Extension. LocalFeedImageDataLoader: FeedImageDataLoaderProtocol
extension LocalFeedImageDataLoader: FeedImageDataLoaderProtocol {
    public typealias LoadResult = FeedImageDataLoaderProtocol.Result
    
    
    public enum LoadError: Error {
        case failed
        case notFound
    }
    
    
    private final class LoadImageDataTask: FeedImageDataLoaderTask {
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
    
    
    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError {_ in LoadError.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(LoadError.notFound)
                })
        }
        
        return task
    }
}


