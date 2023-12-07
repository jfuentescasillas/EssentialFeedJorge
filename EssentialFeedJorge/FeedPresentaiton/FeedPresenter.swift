//
//  FeedPresenter.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 11/10/23.
//

import Foundation


// MARK: - Protocols
public protocol FeedViewProtocol {
    func display(_ viewModel: FeedViewModel)
}


public protocol FeedErrorViewProtocol {
    func display(_ viewModel: FeedErrorViewModel)
}


// MARK: - FeedPresenter class
public final class FeedPresenter {
    private let feedView: FeedViewProtocol
    private let loadingView: ResourceLoadingViewProtocol
    private let errorView: FeedErrorViewProtocol
    
    private var feedLoadError: String {
        return NSLocalizedString("GENERIC_CONNECTION_ERROR",
                                 tableName: "Shared",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
    
    
    public init(feedView: FeedViewProtocol, loadingView: ResourceLoadingViewProtocol, errorView: FeedErrorViewProtocol) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}


