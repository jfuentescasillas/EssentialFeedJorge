//
//  FeedErrorViewModel.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 11/10/23.
//


public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
