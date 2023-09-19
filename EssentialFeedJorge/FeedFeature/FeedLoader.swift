//
//  FeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 02/08/23.
//


import Foundation


public protocol FeedLoaderProtocol {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
