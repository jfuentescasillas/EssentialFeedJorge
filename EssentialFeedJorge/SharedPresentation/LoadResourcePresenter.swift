//
//  LoadResourcePresenter.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 07/12/23.
//


import Foundation


public final class LoadResourcePresenter {
    private let feedView: FeedViewProtocol
    private let loadingView: FeedLoadingViewProtocol
    private let errorView: FeedErrorViewProtocol
    
    
    public init(feedView: FeedViewProtocol, loadingView: FeedLoadingViewProtocol, errorView: FeedErrorViewProtocol) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    
    private var feedLoadError: String {
        let localizedString = NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed when we can't load the image feed from the server")
        
        return localizedString
    }
    
    
    public static var title: String {
        let returnTitle = NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view")
        
        return returnTitle
    }
    
    
    // MARK: - Methods
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
