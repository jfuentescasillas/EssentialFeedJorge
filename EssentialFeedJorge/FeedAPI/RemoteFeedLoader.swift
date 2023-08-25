//
//  RemoteFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 03/08/23.
//


import Foundation


// MARK: - RemoteFeedLoader
public final class RemoteFeedLoader: FeedLoaderProtocol {
    // MARK: - Properties
    private let url: URL
    private let client: HTTPClientProtocol
    public typealias Result = LoadFeedResult
    
    
    // MARK: - Enums
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    
    // MARK: - Inits
    public init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    
    // MARK: - Public Methods
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}


// MARK: - Extension. Array. toModels()
extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
    }
}
