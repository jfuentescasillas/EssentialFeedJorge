//
//  FeedUIComposer.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit
import EssentialFeedJorge


public final class FeedUIComposer {
    private init() {}
    
    
    public static func feedComposedWith(feedLoader: FeedLoaderProtocol, imageLoader: FeedImageDataLoaderProtocol) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = FeedViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = FeedPresenter(
            loadingView: WeakRefVirtualProxy(refreshController),
            feedView: FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
        )
        
        return feedController
    }
    
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoaderProtocol) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedImageCellController(viewModel:
                    FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init))
            }
        }
    }
}


// MARK: - Adapter Class
private final class FeedViewAdapter: FeedViewProtocol {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoaderProtocol
    
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoaderProtocol) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            FeedImageCellController(viewModel:
                                        FeedImageViewModel(
                                            model: model,
                                            imageLoader: imageLoader,
                                            imageTransformer: UIImage.init
                                        )
            )
        }
    }
}


// MARK: - WeakRefViertualProxy
private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}


// MARK: - Extension. WeakRefVirtualProxy
extension WeakRefVirtualProxy: FeedLoadingViewProtocol where T: FeedLoadingViewProtocol {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}


// MARK: - FeedLoaderPresentationAdapter Class
private final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
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
