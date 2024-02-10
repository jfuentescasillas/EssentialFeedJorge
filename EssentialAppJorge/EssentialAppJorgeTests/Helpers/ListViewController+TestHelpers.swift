//
//  FeedViewController+TestHelpers.swift renamed to ListViewController+TestHelpers
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit
import EssentialFeedJorgeiOS


// MARK: - Extension. ListViewController
extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    var errorMessage: String? {
        return errorView.message
    }
    
    
    func simulateErrorViewTap() {
        errorView.simulateTap()
    }
    
    
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    
    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}
    
 
extension ListViewController {
    private func setSmallFrameToPreventRenderingCells() {
        tableView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
    }
    
    
    private func replaceRefreshControlWithFakeForiOS17PlusSupport() {
        let fakeRefreshControl = FakeUIRefreshControl()
        
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fakeRefreshControl.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        
        refreshControl = fakeRefreshControl
    }
    
    
    private class FakeUIRefreshControl: UIRefreshControl {
        private var _isRefreshing = false
        override var isRefreshing: Bool { _isRefreshing }
        
        
        override func beginRefreshing() {
            _isRefreshing = true
        }
        
        
        override func endRefreshing() {
            _isRefreshing = false
        }
    }
    
    
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }

    
    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }

    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    
    private var feedImagesSection: Int { 0 }
    private var feedLoadMoreSection: Int { 1 }
    
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageTableViewCell? {
        return feedImageView(at: index) as? FeedImageTableViewCell
    }
    
    
    /* ACTUALIZAR DEPUÉS. PERTENECE A iOS 15 Update #2: https://github.com/essentialdevelopercom/essential-feed-case-study/pull/70/commits/f2ae3faa924b76b182b8bdc9824f3ebeba446c9d
     @discardableResult
    func simulateFeedImageBecomingVisibleAgain(at row: Int) -> FeedImageTableViewCell? {
        let view = simulateFeedImageViewNotVisible(at: row)
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, willDisplay: view!, forRowAt: index)
        
        return view
    } */
    
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageTableViewCell? {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    
    func numberOfRenderedFeedImageViews() -> Int {
        return numberOfRows(in: feedImagesSection)
    }
    
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        cell(row: row, section: feedImagesSection)
    }
}


extension ListViewController {
    private var commentsSection: Int { 0 }

    
    func numberOfRenderedComments() -> Int {
        return numberOfRows(in: commentsSection)
    }
    
    
    func commentMessage(at row: Int) -> String? {
        return commentView(at: row)?.messageLabel.text
    }
    
    
    func commentDate(at row: Int) -> String? {
        return commentView(at: row)?.dateLabel.text
    }
    
    
    func commentUsername(at row: Int) -> String? {
        return commentView(at: row)?.usernameLabel.text
    }
    
    
    private func commentView(at row: Int) -> ImageCommentCell? {
        cell(row: row, section: commentsSection) as? ImageCommentCell
    }
}
