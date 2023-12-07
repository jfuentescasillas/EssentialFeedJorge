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
extension WeakRefVirtualProxy: ResourceLoadingViewProtocol where T: ResourceLoadingViewProtocol {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}


extension WeakRefVirtualProxy: ResourceViewProtocol where T: ResourceViewProtocol, T.ResourceViewModel == UIImage {
    func display(_ model: UIImage) {
        object?.display(model)
    }
}


extension WeakRefVirtualProxy: ResourceErrorViewProtocol where T: ResourceErrorViewProtocol {
    func display(_ viewModel: ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}
