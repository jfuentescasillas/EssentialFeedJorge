//
//  RemoteFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 03/08/23.
//


import Foundation


// MARK: - Enums
public enum HTTPClientResult {
    case success(HTTPURLResponse)
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
    
    
    // MARK: Properties
    private let url: URL
    private let client: HTTPClient
    
    // MARK: Inits
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    
    // MARK: - Public Methods
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.invalidData)
            
            case .failure:
                completion(.connectivity)
            }
        }
    }
}
