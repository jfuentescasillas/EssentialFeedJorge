//
//  FeedImageDataStore.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 15/11/23.
//


import Foundation


// MARK: - FeedImageDataStoreProtocol
public protocol FeedImageDataStoreProtocol {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?

    @available(*, deprecated)
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    
    @available(*, deprecated)
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}


public extension FeedImageDataStoreProtocol {
    func insert(_ data: Data, for url: URL) throws {
        let group = DispatchGroup()
        group.enter()
       
        var result: InsertionResult!
        
        insert(data, for: url) {
            result = $0
            group.leave()
        }
        
        group.wait()
       
        return try result.get()
    }

    func retrieve(dataForURL url: URL) throws -> Data? {
        let group = DispatchGroup()
        group.enter()
       
        var result: RetrievalResult!
        
        retrieve(dataForURL: url) {
            result = $0
            group.leave()
        }
        
        group.wait()
        
        return try result.get()
    }

    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {}
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {}
}
