//
//  WeakRefVirtualProxy.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 22/09/23.
//


import UIKit
import EssentialFeedJorge
import EssentialFeedJorgeiOS


// MARK: - WeakRefViertualProxy
final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}


// MARK: - Extensions. WeakRefVirtualProxy
extension WeakRefVirtualProxy: FeedLoadingViewProtocol where T: FeedLoadingViewProtocol {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}


extension WeakRefVirtualProxy: FeedImageViewProtocol where T: FeedImageViewProtocol, T.Image == UIImage {
    func display(_ model: FeedImageViewModel<UIImage>) {
        object?.display(model)
    }
}


extension WeakRefVirtualProxy: FeedErrorViewProtocol where T: FeedErrorViewProtocol {
    func display(_ viewModel: FeedErrorViewModel) {
        object?.display(viewModel)
    }
}
