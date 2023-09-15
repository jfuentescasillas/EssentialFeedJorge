//
//  FeedImageCellController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


final class FeedImageCellController {
    private let viewModel: FeedImageViewModel<UIImage>
    
    
    init(viewModel: FeedImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    
    func view() -> UITableViewCell {
        let cell = binded(FeedImageTableViewCell())
        viewModel.loadImageData()
        
        return cell
    }
    
    
    func preload() {
        viewModel.loadImageData()
    }
    
    
    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }
    
    
    private func binded(_ cell: FeedImageTableViewCell) -> FeedImageTableViewCell {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImageData
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }
        
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }
        
        viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }
        
        return cell
    }
}

