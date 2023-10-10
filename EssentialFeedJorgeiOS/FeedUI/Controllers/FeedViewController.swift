//
//  FeedViewController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 12/09/23.
//


import UIKit


// MARK: - Protocols
protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}


// MARK: - FeedViewController Class
public final class FeedViewController: UITableViewController  {
    var delegate: FeedViewControllerDelegate?
    var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private(set) public var errorView: ErrorView?
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        refresh()
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
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
    
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
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
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
}


// MARK: - Extension. FeedViewController. FeedErrorView
extension FeedViewController: FeedErrorViewProtocol {
    func display(_ viewModel: FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }
}
