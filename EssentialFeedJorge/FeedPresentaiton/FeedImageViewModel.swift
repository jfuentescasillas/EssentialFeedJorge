//
//  FeedImageViewModel.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 11/10/23.
//


public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
   
    public var hasLocation: Bool {
        return location != nil
    }
}
