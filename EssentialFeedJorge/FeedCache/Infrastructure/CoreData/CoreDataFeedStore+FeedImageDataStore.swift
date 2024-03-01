//
//  CoreDataFeedStore+FeedImageDataLoader renamed to CoreDataFeedStore+FeedImageDataStore
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 15/11/23.
//


import Foundation


// MARK: - Extension. CoreDataFeedStore: FeedImageDataStoreProtocol
extension CoreDataFeedStore: FeedImageDataStoreProtocol {
    public func insert(_ data: Data, for url: URL) throws {
        try performSync { context in
            Result {
                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            }
        }
    }
    
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
            try performSync { context in
                Result {
                try ManagedFeedImage.data(with: url, in: context)
            }
        }
    }
}
