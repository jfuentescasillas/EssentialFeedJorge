//
//  FeedViewController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 12/09/23.
//


import UIKit
import EssentialFeedJorge


// MARK: - Protocols
public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}


// MARK: - FeedViewController Class
public final class FeedViewController: UITableViewController  {
    public var delegate: FeedViewControllerDelegate?
    private var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var loadingControllers = [IndexPath: FeedImageCellController]()
    
    
    // MARK: - Outlets in the storyboard
    @IBOutlet private(set) public var errorView: ErrorView?
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }
    
    
    // MARK: - Action methods
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    
    // MARK: - TableViewDataSource Methods
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    
    // MARK: - TableViewDelegate Methods
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    
    // MARK: - Custom Methods
    public func display(_ cellControllers: [FeedImageCellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }
    
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        
        return controller
    }
    
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}


// MARK: - Extension. FeedViewController. UITableViewDataSourcePrefetching
extension FeedViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
}


// MARK: - Extension. FeedViewController. FeedLoadingViewProtocol
extension FeedViewController: FeedLoadingViewProtocol {
    public func display(_ viewModel: FeedLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}


// MARK: - Extension. FeedViewController. FeedErrorView
extension FeedViewController: FeedErrorViewProtocol {
    public func display(_ viewModel: FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }
}
