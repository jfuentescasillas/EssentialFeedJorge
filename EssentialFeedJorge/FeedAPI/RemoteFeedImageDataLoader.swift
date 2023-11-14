//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 13/11/23.
//


import Foundation


public final class RemoteFeedImageDataLoader: FeedImageDataLoaderProtocol {
    private let client: HTTPClientProtocol
    
    
    public init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    
    public enum Error: Swift.Error {
        case connectivity
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
    
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { (data, response) in
                    let isValidResponse = response.statusCode == 200 && !data.isEmpty
                   
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
        }
        
        return task
    }
}
