//
//  FeedPresenter.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 11/10/23.
//

import Foundation


// MARK: - View Models
public struct FeedViewModel {
    public let feed: [FeedImage]
}


public struct FeedLoadingViewModel {
    public let isLoading: Bool
}


public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}


// MARK: - Protocols
public protocol FeedViewProtocol {
    func display(_ viewModel: FeedViewModel)
}


public protocol FeedLoadingViewProtocol {
    func display(_ viewModel: FeedLoadingViewModel)
}


public protocol FeedErrorViewProtocol {
    func display(_ viewModel: FeedErrorViewModel)
}


// MARK: - FeedPresenter class
public final class FeedPresenter {
    private let feedView: FeedViewProtocol
    private let loadingView: FeedLoadingViewProtocol
    private let errorView: FeedErrorViewProtocol
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
    
    
    public init(feedView: FeedViewProtocol, loadingView: FeedLoadingViewProtocol, errorView: FeedErrorViewProtocol) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    
    public func didFinishDownloadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}


