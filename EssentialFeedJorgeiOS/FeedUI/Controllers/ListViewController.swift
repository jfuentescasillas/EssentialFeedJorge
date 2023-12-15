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


public protocol CellControllerProtocol {
    func view(in tableView: UITableView) -> UITableViewCell
    func preload()
    func cancelLoad()
}


// MARK: - ListViewController Class
public final class ListViewController: UITableViewController  {
    public var delegate: FeedViewControllerDelegate?
    private var tableModel = [CellControllerProtocol]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var loadingControllers = [IndexPath: CellControllerProtocol]()
    
    
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
    public func display(_ cellControllers: [CellControllerProtocol]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }
    
    
    private func cellController(forRowAt indexPath: IndexPath) -> CellControllerProtocol {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        
        return controller
    }
    
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}


// MARK: - Extension. ListViewController. UITableViewDataSourcePrefetching
extension ListViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
}


// MARK: - Extension. ListViewController. FeedLoadingViewProtocol
extension ListViewController: ResourceLoadingViewProtocol {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}


// MARK: - Extension. ListViewController. FeedErrorView
extension ListViewController: ResourceErrorViewProtocol {
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView?.message = viewModel.message
    }
}
