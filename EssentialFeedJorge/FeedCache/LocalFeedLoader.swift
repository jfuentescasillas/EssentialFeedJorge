//
//  LocalFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 17/08/23.
//


import Foundation


// MARK: - LocalFeedLoader Class
public final class LocalFeedLoader {
    private let store: FeedStoreProtocol
    private let currentDate: () -> Date
    
    
    public init(store: FeedStoreProtocol, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}


// MARK: - Extension. LocalFeedLoader. Save
extension LocalFeedLoader {
    public typealias SaveResult = Result<Void, Error>

    
    public func save(feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] deletionResult in
            guard let self else { return }
            
            switch deletionResult {
            case .success:
                self.cache(feed, with: completion)
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] insertionResult in
            guard self != nil else { return }
            
            completion(insertionResult)
        }
    }
}
    
    
    
// MARK: - Extension. LocalFeedLoader. Load
extension LocalFeedLoader: FeedLoaderProtocol {
    public typealias LoadResult = FeedLoaderProtocol.Result

    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case let .success(.some(cache)) where FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                completion(.success(cache.feed.toModels()))
                
            case .success:
                completion(.success([]))
            }
        }
    }
}
 

// MARK: - Extension. LocalFeedLoader. validateCache
extension LocalFeedLoader {
    public typealias ValidationResult = Result<Void, Error>

    
    public func validateCache(completion: @escaping (ValidationResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed(completion: completion)
                
            case let .success(.some(cache)) where !FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed { _ in completion(.success(())) }
                
            case .success:
                completion(.success(()))
            }
        }
    }
}


// MARK: - Extension. Array. toLocal()
private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}


// MARK: - Extension. Array. toModels()
private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}
