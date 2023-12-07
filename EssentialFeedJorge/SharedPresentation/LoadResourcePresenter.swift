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
    
    
    public static var loadError: String {
        let localizedString = NSLocalizedString(
            "GENERIC_CONNECTION_ERROR",
            tableName: "Shared",
            bundle: Bundle(for: Self.self),
            comment: "Error message displayed when we can't load the resource from the server")
        
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
        errorView.display(.error(message: Self.loadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
