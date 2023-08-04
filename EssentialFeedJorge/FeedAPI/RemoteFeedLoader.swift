//
//  RemoteFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 03/08/23.
//


import Foundation


// MARK: - Enums
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


// MARK: - Protocol HTTPClient
public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}


// MARK: - RemoteFeedLoader
public final class RemoteFeedLoader {
    // MARK: Enums
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }


    // MARK: Properties
    private let url: URL
    private let client: HTTPClient
    
    // MARK: Inits
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    
    // MARK: - Public Methods
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                if let root = try? JSONDecoder().decode(Root.self, from: data),
                   response.statusCode == 200 {
                    completion(.success(root.items.map { $0.item
                    }))
                } else {
                    completion(.failure(.invalidData))
                }

            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}


// MARK: - Private Root
private struct Root: Decodable {
    let items: [Item]
}


private struct Item: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    var item: FeedItem {
        let feedItem = FeedItem(
            id: id,
            description: description,
            location: location,
            imageURL: image)
        
        return feedItem
    }
}
