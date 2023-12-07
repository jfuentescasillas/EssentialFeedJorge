//
//  FeedViewAdapter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 22/09/23.
//


import UIKit
import EssentialFeedJorge
import EssentialFeedJorgeiOS


// MARK: - Adapter Class
final class FeedViewAdapter: ResourceViewProtocol {
    private weak var controller: FeedViewController?
    private let imageLoader: (URL) -> FeedImageDataLoaderProtocol.Publisher
    
    
    init(controller: FeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoaderProtocol.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init)
            
            return view
        })
    }
}
