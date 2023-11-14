//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 13/11/23.
//


import Foundation


public final class RemoteFeedImageDataLoader {
    private let client: HTTPClientProtocol
    
    
    public init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    
    private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoaderProtocol.Result) -> Void)?
        var wrapped: HTTPClientTask?
        
        
        init(_ completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) {
            self.completion = completion
        }
        
        
        func complete(with result: FeedImageDataLoaderProtocol.Result) {
            completion?(result)
        }
        
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    
    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, !data.isEmpty {
                    task.complete(with: .success(data))
                } else {
                    task.complete(with: .failure(Error.invalidData))
                }
                
            case let .failure(error):
                task.complete(with: .failure(error))
            }
        }
        
        return task
    }
}
