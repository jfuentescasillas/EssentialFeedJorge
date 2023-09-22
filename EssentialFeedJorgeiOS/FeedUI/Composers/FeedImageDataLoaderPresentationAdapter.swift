//
//  FeedImageDataLoaderPresentationAdapter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 22/09/23.
//


import EssentialFeedJorge


// MARK: - FeedImageDataLoaderPresentationAdapter
final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoaderProtocol
    private var task: FeedImageDataLoaderTask?
    
    var presenter: FeedImagePresenter<View, Image>?
    
    
    init(model: FeedImage, imageLoader: FeedImageDataLoaderProtocol) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }
    
    
    func didCancelImageRequest() {
        task?.cancel()
    }
}
