//
//  RemoteFeedItem.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 17/08/23.
//

import Foundation


internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
