//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 22/09/23.
//


import EssentialFeedJorge
import EssentialFeedJorgeiOS
import Combine


// MARK: - FeedLoaderPresentationAdapter Class
final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let feedLoader: () -> AnyPublisher<[FeedImage], Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<[FeedImage], FeedViewAdapter>?
    
    
    init(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) {
        self.feedLoader = feedLoader
    }
    
    
    func didRequestFeedRefresh () {
        presenter?.didStartLoading()
        
        cancellable = feedLoader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    switch completion {
                    case .finished:
                        break
                        
                    case let .failure(error):
                        self.presenter?.didFinishLoading(with: error)
                    }
                }, receiveValue: { [weak self] feed in
                    guard let self else { return }
                    
                    self.presenter?.didFinishLoading(with: feed)
                }
            )
    }
}
