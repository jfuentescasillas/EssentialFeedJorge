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
    
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>
    
    
    init(controller: FeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoaderProtocol.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.url)
            })
            
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                mapper: UIImage.tryMake)
            
            return view
        })
    }
}


// MARK: - Extension. UIImage
extension UIImage {
    struct InvalidImageData: Error {}

    
    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }
        
        return image
    }
}
