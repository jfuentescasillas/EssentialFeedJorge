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
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(presenter: presenter)
        let feedController = FeedViewController(refreshController: refreshController)
        presenter.loadingView = refreshController
        presenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
        
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


// MARK: - Adapter
private final class FeedViewAdapter: FeedViewProtocol {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoaderProtocol
    
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoaderProtocol) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    
    func display(feed: [FeedImage]) {
        controller?.tableModel = feed.map { model in
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
