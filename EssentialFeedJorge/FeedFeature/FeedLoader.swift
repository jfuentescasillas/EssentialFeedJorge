//
//  FeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 02/08/23.
//


import Foundation


public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}


protocol FeedLoaderProtocol {
    associatedtype Error: Swift.Error
    
    
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
