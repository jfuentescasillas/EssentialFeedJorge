//
//  RemoteFeedLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 03/08/23.
//


import Foundation


public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>


public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClientProtocol) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
