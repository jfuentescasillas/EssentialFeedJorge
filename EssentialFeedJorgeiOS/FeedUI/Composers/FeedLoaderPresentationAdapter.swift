//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 22/09/23.
//


import EssentialFeedJorge


// MARK: - FeedLoaderPresentationAdapter Class
final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let feedLoader: FeedLoaderProtocol
    var presenter: FeedPresenter?
    
    
    init(feedLoader: FeedLoaderProtocol) {
        self.feedLoader = feedLoader
    }
    
    
    // MARK: - Delegate Method
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        
        feedLoader.load { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(feed):
                self.presenter?.didFinishLoadingFeed(with: feed)
                
            case let .failure(error):
                self.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
