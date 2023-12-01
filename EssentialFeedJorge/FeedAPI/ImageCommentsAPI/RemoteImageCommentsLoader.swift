//
//  RemoteImageCommentsLoader.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 30/11/23.
//


import Foundation


public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>


public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClientProtocol) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
