//
//  RemoteFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 03/08/23.
//


import Foundation


// MARK: - RemoteFeedLoader
public final class RemoteFeedLoader {
    // MARK: - Enums
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }


    // MARK: - Properties
    private let url: URL
    private let client: HTTPClient
    
    // MARK: - Inits
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    
    // MARK: - Public Methods
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                do {
                    let items = try FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }

            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
