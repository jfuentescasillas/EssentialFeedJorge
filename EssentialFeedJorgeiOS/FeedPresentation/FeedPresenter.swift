//
//  FeedPresenter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 18/09/23.
//


import EssentialFeedJorge


// MARK: - FeedLoadingView Elements
struct FeedLoadingViewModel {
    let isLoading: Bool
}


protocol FeedLoadingViewProtocol {
    func display(_ viewModel: FeedLoadingViewModel)
}


// MARK: - FeedView Elements
struct FeedViewModel {
    let feed: [FeedImage]
}


protocol FeedViewProtocol {
    func display(_ viewModel: FeedViewModel)
}


// MARK: - FeedPresenter Class
final class FeedPresenter {
    private let loadingView: FeedLoadingViewProtocol
    private let feedView: FeedViewProtocol
    
    
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
