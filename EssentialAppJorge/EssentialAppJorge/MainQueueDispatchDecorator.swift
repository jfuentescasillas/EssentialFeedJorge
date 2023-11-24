//
//  MainQueueDispatchDecorator.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 22/09/23.
//


import Foundation
import EssentialFeedJorge


// MARK: - Decorator ClassExtensions
final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}


// MARK: - Extension. Decorator conforms to FeedLoaderProtocol
extension MainQueueDispatchDecorator: FeedLoaderProtocol where T == FeedLoaderProtocol {
    func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
        decoratee.load { [weak self] result in
            guard let self else { return }
            
            self.dispatch {
                completion(result)
            }
        }
    }
}


// MARK: - Extension. Decorator conforms to FeedImageDataLoaderProtocol
extension MainQueueDispatchDecorator: FeedImageDataLoaderProtocol where T == FeedImageDataLoaderProtocol {
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            guard let self else { return }
            
            self.dispatch {
                completion(result)
            }
        }
    }
}


