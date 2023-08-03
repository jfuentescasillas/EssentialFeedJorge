//
//  RemoteFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 03/08/23.
//


import Foundation


// MARK: - Protocol HTTPClient
public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}


// MARK: - RemoteFeedLoader
public final class RemoteFeedLoader {
    // MARK: Enums
    public enum Error: Swift.Error {
        case connectivity
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
    public func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
