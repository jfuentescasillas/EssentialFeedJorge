//
//  RemoteFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 03/08/23.
//


import Foundation


// MARK: - Protocol HTTPClient
public protocol HTTPClient {
    func get(from url: URL)
}


// MARK: - RemoteFeedLoader
public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    
    public func load() {
        client.get(from: url)
    }
}
