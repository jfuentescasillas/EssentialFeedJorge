//
//  FeedPresenter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 18/09/23.
//


import Foundation
import EssentialFeedJorge


// MARK: - Protocols
protocol FeedLoadingViewProtocol {
    func display(_ viewModel: FeedLoadingViewModel)
}


protocol FeedViewProtocol {
    func display(_ viewModel: FeedViewModel)
}


// MARK: - FeedPresenter Class
final class FeedPresenter {
    private let loadingView: FeedLoadingViewProtocol
    private let feedView: FeedViewProtocol
    static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
    
    
    init(loadingView: FeedLoadingViewProtocol, feedView: FeedViewProtocol) {
        self.loadingView = loadingView
        self.feedView = feedView
    }
    
    
    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    
    func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
