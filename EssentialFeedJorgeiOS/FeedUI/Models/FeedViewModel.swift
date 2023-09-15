//
//  FeedViewModel.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import Foundation
import EssentialFeedJorge


final class FeedViewModel {
    private let feedLoader: FeedLoaderProtocol

    
    init(feedLoader: FeedLoaderProtocol) {
        self.feedLoader = feedLoader
    }
    
    
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    private(set) var isLoading: Bool = false {
        didSet {
            onChange?(self)
        }
    }
    
    
    func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            guard let self else { return }
            
            if let feed = try? result.get() {
                self.onFeedLoad?(feed)
            }
            
            self.isLoading = false
        }
    }
}


