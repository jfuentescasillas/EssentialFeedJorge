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
    private var isLoading = false
    
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    
    func loadResource() {
        guard !isLoading else { return }
        
        presenter?.didStartLoading()
        isLoading = true
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                guard let self else { return }
                
                self.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    switch completion {
                    case .finished:
                        break
                        
                    case let .failure(error):
                        self.presenter?.didFinishLoading(with: error)
                    }
                    
                    self.isLoading = false
                }, receiveValue: { [weak self] resource in
                    guard let self else { return }
                    
                    self.presenter?.didFinishLoading(with: resource)
                }
            )
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
