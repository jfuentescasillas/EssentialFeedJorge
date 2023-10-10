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


protocol FeedErrorViewProtocol {
    func display(_ viewModel: FeedErrorViewModel)
}


// MARK: - FeedPresenter Class
final class FeedPresenter {
    private let loadingView: FeedLoadingViewProtocol
    private let feedView: FeedViewProtocol
    private let errorView: FeedErrorViewProtocol
    static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
    
        
    init(loadingView: FeedLoadingViewProtocol, feedView: FeedViewProtocol, errorView: FeedErrorViewProtocol) {
        self.loadingView = loadingView
        self.feedView = feedView
        self.errorView = errorView
    }
    
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    
    func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    
    func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
