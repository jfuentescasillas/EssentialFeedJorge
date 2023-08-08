//
//  RemoteFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 03/08/23.
//


import Foundation


// MARK: - RemoteFeedLoader
public final class RemoteFeedLoader {
    // MARK: - Properties
    private let url: URL
    private let client: HTTPClient
    public typealias Result = LoadFeedResult<Error>
    
    
    // MARK: - Enums
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    
    // MARK: - Inits
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    
    // MARK: - Public Methods
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, from: response))

            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }    
}
