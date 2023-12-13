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
public final class FeedImageCellController {
    public typealias ResourceViewModel = UIImage
    
    
    private let viewModel: FeedImageViewModel
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageTableViewCell?
    
    
    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    

    private func releaseCellForReuse() {
        cell = nil
    }
}


// MARK: - Extension. ResourceViewProtocol
extension FeedImageCellController: ResourceViewProtocol {
    public func display(_ viewModel: UIImage) {
        cell?.feedImageView.setImageAnimated(viewModel)
    }
}

// MARK: - Extension. ResourceLoadingViewProtocol
extension FeedImageCellController: ResourceLoadingViewProtocol {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }
}


extension FeedImageCellController: ResourceErrorViewProtocol {
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.message == nil
    }
}


// MARK: - Extension. CellControllerProtocol
extension FeedImageCellController: CellControllerProtocol {
    public func view(in tableView: UITableView) -> UITableViewCell {
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
    
    
    public func preload() {
        delegate.didRequestImage()
    }
    
    
    public func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
}
