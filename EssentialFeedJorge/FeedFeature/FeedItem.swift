//
//  FeedItem.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 02/08/23.
//


import Foundation


public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
