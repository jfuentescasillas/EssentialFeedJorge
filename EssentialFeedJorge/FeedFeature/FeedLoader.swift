//
//  FeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 02/08/23.
//


import Foundation


public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}


protocol FeedLoaderProtocol {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
