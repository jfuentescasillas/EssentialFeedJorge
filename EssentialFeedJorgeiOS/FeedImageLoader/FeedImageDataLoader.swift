//
//  FeedImageDataLoader.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import Foundation


// MARK: - Protocols
public protocol FeedImageDataLoaderTask {
    func cancel()
}


public protocol FeedImageDataLoaderProtocol {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
