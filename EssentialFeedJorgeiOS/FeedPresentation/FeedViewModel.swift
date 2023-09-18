//
//  FeedViewModel.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import EssentialFeedJorge


final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoaderProtocol

    
    init(feedLoader: FeedLoaderProtocol) {
        self.feedLoader = feedLoader
    }
    
    
    var onLoadingStateChange: ((Bool) -> Void)?
    var onFeedLoad: Observer<[FeedImage]>?
    
    
    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            guard let self else { return }
            
            if let feed = try? result.get() {
                self.onFeedLoad?(feed)
            }
            
            self.onLoadingStateChange?(false)
        }
    }
}


