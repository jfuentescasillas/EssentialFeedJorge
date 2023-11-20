//
//  FeedLoaderCacheDecorator.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 20/11/23.
//


import EssentialFeedJorge


// MARK: - Class FeedLoaderCacheDecorator
public final class FeedLoaderCacheDecorator: FeedLoaderProtocol {
    private let decoratee: FeedLoaderProtocol
    private let cache: FeedCacheProtocol
    
    
    public init(decoratee: FeedLoaderProtocol, cache: FeedCacheProtocol) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    
    public func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
        decoratee.load { [weak self] result in
            guard let self else { return }
            
            completion(result.map { feed in
                self.cache.saveIgnoringResult(feed)
                
                return feed
            })
        }
    }
}


// MARK: - Extension. FeedCacheProtocol
private extension FeedCacheProtocol {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed) { _ in }
    }
}
