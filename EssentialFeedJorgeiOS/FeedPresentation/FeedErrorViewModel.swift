//
//  FeedErrorViewModel.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 10/10/23.
//


struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
