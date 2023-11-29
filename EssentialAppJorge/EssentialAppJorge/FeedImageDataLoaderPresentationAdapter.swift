//
//  FeedImageDataLoaderPresentationAdapter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 22/09/23.
//


import Foundation
import Combine
import EssentialFeedJorge
import EssentialFeedJorgeiOS


// MARK: - FeedImageDataLoaderPresentationAdapter
final class FeedImageDataLoaderPresentationAdapter<View: FeedImageViewProtocol, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private let model: FeedImage
    private let imageLoader: (URL) -> FeedImageDataLoaderProtocol.Publisher
    private var cancellable: Cancellable?
    
    var presenter: FeedImagePresenter<View, Image>?
    
    
    init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoaderProtocol.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        
        cancellable = imageLoader(model.url)
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishLoadingImageData(with: error, for: model)
                    }
                }, receiveValue: { [weak self] data in
                    self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                }
            )
    }
    
    
    func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
