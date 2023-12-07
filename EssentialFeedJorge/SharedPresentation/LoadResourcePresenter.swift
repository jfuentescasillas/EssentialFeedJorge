//
//  LoadResourcePresenter.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 07/12/23.
//


import Foundation


// MARK: - Protocol. ResourceView
public protocol ResourceViewProtocol {
    associatedtype ResourceViewModel

    func display(_ viewModel: ResourceViewModel)
}



public final class LoadResourcePresenter<Resource, View: ResourceViewProtocol> {
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    
    private let resourceView: View
    private let loadingView: FeedLoadingViewProtocol
    private let errorView: FeedErrorViewProtocol
    private let mapper: Mapper
    
    
    public init(resourceView: View, loadingView: FeedLoadingViewProtocol, errorView: FeedErrorViewProtocol, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    
    private var feedLoadError: String {
        let localizedString = NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed when we can't load the image feed from the server")
        
        return localizedString
    }
    
    
    // MARK: - Methods
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    
    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
