//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 21/11/23.
//


import Foundation
import EssentialFeedJorge


// MARK: - Class FeedImageDataLoaderCacheDecorator
public final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoaderProtocol {
    private let decoratee: FeedImageDataLoaderProtocol
    private let cache: FeedImageDataCacheProtocol
    
    
    public init(decoratee: FeedImageDataLoaderProtocol, cache: FeedImageDataCacheProtocol) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        let decorateeWithLoadImageData = decoratee.loadImageData(from: url) { [weak self] result in
            guard let self else { return }
            
            completion(result.map { data in
                self.cache.save(data, for: url) { _ in }
                
                return data
            })
        }
        
        return decorateeWithLoadImageData
    }
}


