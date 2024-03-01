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
extension LocalFeedImageDataLoader: FeedImageDataCacheProtocol {
    public enum SaveError: Error {
        case failed
    }
    
    
    public func save(_ data: Data, for url: URL) throws {
        do {
            try store.insert(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
}


// MARK: - Extension. LocalFeedImageDataLoader: FeedImageDataLoaderProtocol
extension LocalFeedImageDataLoader: FeedImageDataLoaderProtocol {
    public enum LoadError: Error {
        case failed
        case notFound
    }
    
    
    public func loadImageData(from url: URL) throws -> Data {
        do {
            if let imageData = try store.retrieve(dataForURL: url) {
                return imageData
            }
        } catch {
            throw LoadError.failed
        }
        
        throw LoadError.notFound
    }
}


