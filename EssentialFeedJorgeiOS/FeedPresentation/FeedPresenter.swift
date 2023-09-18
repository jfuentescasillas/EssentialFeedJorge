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
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoaderProtocol

    
    init(feedLoader: FeedLoaderProtocol) {
        self.feedLoader = feedLoader
    }
    
    
    var loadingView: FeedLoadingViewProtocol?
    var feedView: FeedViewProtocol?
    
    
    func loadFeed() {
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader.load { [weak self] result in
            guard let self else { return }
            
            if let feed = try? result.get() {
                self.feedView?.display(FeedViewModel(feed: feed))
            }
            
            self.loadingView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}
