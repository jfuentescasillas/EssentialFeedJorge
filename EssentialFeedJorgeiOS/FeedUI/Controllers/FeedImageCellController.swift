//
//  FeedImageCellController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit
import EssentialFeedJorge


// MARK: - Protocols
public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}


// MARK: - FeedImageCellController Class
public final class FeedImageCellController: FeedImageViewProtocol, ResourceViewProtocol, ResourceLoadingViewProtocol, ResourceErrorViewProtocol {
    public typealias ResourceViewModel = UIImage
    
    
    private let viewModel: FeedImageViewModel<UIImage>
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageTableViewCell?
    
    
    public init(viewModel: FeedImageViewModel<UIImage>, delegate: FeedImageCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        cell?.feedImageView.image = nil
        cell?.onRetry = delegate.didRequestImage
        cell?.onReuse = { [weak self] in
            guard let self else { return }
            
            self.releaseCellForReuse()
        }
        
        delegate.didRequestImage()
        
        return cell!
    }
    
    
    func preload() {
        delegate.didRequestImage()
    }
    
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    
    public func display(_ viewModel: FeedImageViewModel<UIImage>) {}
    
    
    public func display(_ viewModel: UIImage) {
        cell?.feedImageView.setImageAnimated(viewModel)
    }
    
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }
    
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.message == nil
    }
    
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
