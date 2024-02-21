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
public final class FeedImageCellController: NSObject {
    public typealias ResourceViewModel = UIImage
    
    
    private let viewModel: FeedImageViewModel
    private let delegate: FeedImageCellControllerDelegate
    private let selection: () -> Void
    private var cell: FeedImageTableViewCell?
    
    
    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.selection = selection
    }
    
    
    private func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    
    private func releaseCellForReuse() {
        cell?.onReuse = nil
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


// MARK: - Extension. UITableViewDataSource
extension FeedImageCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        cell?.feedImageView.image = nil
        cell?.feedImageContainer.isShimmering = true
        cell?.feedImageRetryButton.isHidden = true
        cell?.onRetry = { [weak self] in
            guard let self else { return }
            
            self.delegate.didRequestImage()
        }
        cell?.onReuse = { [weak self] in
            guard let self else { return }
            
            self.releaseCellForReuse()
        }
        
        delegate.didRequestImage()
        
        return cell!
    }
}


// MARK: - Extension. UITableViewDelegate
extension FeedImageCellController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }
    
    
    /* ACTUALIZAR DEPUÉS. PERTENECE A iOS 15 Update #2: https://github.com/essentialdevelopercom/essential-feed-case-study/pull/70/commits/f2ae3faa924b76b182b8bdc9824f3ebeba446c9d
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cell = cell as? FeedImageTableViewCell
        delegate.didRequestImage()
    } */
}


// MARK: - Extension. UITableViewDataSourcePrefetching
extension FeedImageCellController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
    
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}
}
