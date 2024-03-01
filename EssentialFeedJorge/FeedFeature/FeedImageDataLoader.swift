//
//  FeedImageDataLoader.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import Foundation


// MARK: - Protocols
public protocol FeedImageDataLoaderProtocol {
    func loadImageData(from url: URL) throws -> Data
}
