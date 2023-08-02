//
//  FeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 02/08/23.
//


import Foundation


enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}


protocol FeedLoaderProtocol {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
