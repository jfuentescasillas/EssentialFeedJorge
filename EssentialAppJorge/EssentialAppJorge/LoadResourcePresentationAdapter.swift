//
//  LoadResourcePresentationAdapter.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 22/09/23.
//


import EssentialFeedJorge
import EssentialFeedJorgeiOS
import Combine


// MARK: - FeedLoaderPresentationAdapter Class
final class LoadResourcePresentationAdapter<Resource, View: ResourceViewProtocol> {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<Resource, View>?
    
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    
    func loadResource() {
        presenter?.didStartLoading()
        
        cancellable = loader()
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
                }, receiveValue: { [weak self] resource in
                    guard let self else { return }
                    
                    self.presenter?.didFinishLoading(with: resource)
                }
            )
    }
}


// MARK: - Extension. FeedViewControllerDelegate
extension LoadResourcePresentationAdapter: FeedViewControllerDelegate {
    func didRequestFeedRefresh() {
        loadResource()
    }
}


// MARK: - Extension. FeedImageCellControllerDelegate
extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    func didRequestImage() {
        loadResource()
    }
    
    
    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
