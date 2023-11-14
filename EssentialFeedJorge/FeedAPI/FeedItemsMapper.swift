//
//  FeedItemsMapper.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 08/08/23.
//


import Foundation


internal final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
        
    
    // MARK: - Private Methods
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
