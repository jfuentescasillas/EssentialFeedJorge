//
//  FeedPresenter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 18/09/23.
//


import EssentialFeedJorge


// MARK: - FeedView Protocols
protocol FeedLoadingViewProtocol {
    func display(isLoading: Bool)
}


protocol FeedViewProtocol {
    func display(feed: [FeedImage])
}


// MARK: - FeedPresenter Class
final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoaderProtocol

    
    init(feedLoader: FeedLoaderProtocol) {
        self.feedLoader = feedLoader
    }
    
    
    var loadingView: FeedLoadingViewProtocol?
    var feedView: FeedViewProtocol?
    
    
    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            guard let self else { return }
            
            if let feed = try? result.get() {
                self.feedView?.display(feed: feed)
            }
            
            self.loadingView?.display(isLoading: false)
        }
    }
}
