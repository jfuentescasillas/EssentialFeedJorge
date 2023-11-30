//
//  RemoteImageCommentsLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 30/11/23.
//


import Foundation


public final class RemoteImageCommentsLoader: FeedLoaderProtocol {
    private let url: URL
    private let client: HTTPClientProtocol

    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    
    public typealias Result = FeedLoaderProtocol.Result

    
    public init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteImageCommentsLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ImageCommentsMapper.map(data, from: response)
            
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}


// MARK: - Extension. It already exists in RemoteFeedLoader.swift
/// Extension. It already exists in RemoteFeedLoader.swift. So I'm commenting it for now
/*
 private extension Array where Element == RemoteFeedItem {
     func toModels() -> [FeedImage] {
         return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
     }
 }
 */
