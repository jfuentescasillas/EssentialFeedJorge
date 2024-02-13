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
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    
    private let resourceView: View
    private let loadingView: ResourceLoadingViewProtocol
    private let errorView: ResourceErrorViewProtocol
    private let mapper: Mapper
    
    
    public init(resourceView: View, loadingView: ResourceLoadingViewProtocol, errorView: ResourceErrorViewProtocol, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    
    public init(resourceView: View, loadingView: ResourceLoadingViewProtocol, errorView: ResourceErrorViewProtocol) where Resource == View.ResourceViewModel {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = { $0 }
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
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }

    
    public func didFinishLoading(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource))
            loadingView.display(ResourceLoadingViewModel(isLoading: false))
        } catch {
            didFinishLoading(with: error)
        }
    }

    
    public func didFinishLoading(with error: Error) {
        errorView.display(.error(message: Self.loadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
