//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 17/11/23.
//


import Foundation
import EssentialFeedJorge


// MARK: - Class FeedImageDataLoaderWithFallbackComposite
public class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoaderProtocol {
    private let primary: FeedImageDataLoaderProtocol
    private let fallback: FeedImageDataLoaderProtocol
    
    
    public init(primary: FeedImageDataLoaderProtocol, fallback: FeedImageDataLoaderProtocol) {
        self.primary = primary
        self.fallback = fallback
    }
    
    
    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?
        
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadImageData(from: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                task.wrapped = self.fallback.loadImageData(from: url, completion: completion)
            }
        }
        
        return task
    }
}


