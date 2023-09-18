//
//  FeedImageCellController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


// MARK: - Protocols
protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}


// MARK: - FeedImageCellController Class
final class FeedImageCellController: FeedImageView {
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageTableViewCell?
    
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedImageTableViewCell
        self.cell = cell
        
        delegate.didRequestImage()
        
        return cell
    }
    
    
    func preload() {
        delegate.didRequestImage()
    }
    
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    
    private func releaseCellForReuse() {
        cell = nil
    }
    
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        
        cell?.feedImageView.image = viewModel.image
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
        cell?.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell?.onRetry = delegate.didRequestImage
    }
}
