//
//  FeedViewController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 12/09/23.
//


import UIKit
import EssentialFeedJorge


// MARK: - FeedViewController Class
public final class FeedViewController: UITableViewController  {
    private var refreshController: FeedRefreshViewController?
    private var imageLoader: FeedImageDataLoaderProtocol?
    private var cellControllers = [IndexPath: FeedImageCellController]()
    private var tableModel = [FeedImage]() {
        didSet {
            tableView.reloadData()            
        }
    }
        
    
    public convenience init(feedLoader: FeedLoaderProtocol, imageLoader: FeedImageDataLoaderProtocol) {
        self.init()
        self.refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        self.imageLoader = imageLoader
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        refreshController?.onRefresh = { [weak self] feed in
            self?.tableModel = feed
        }
        
        tableView.prefetchDataSource = self
        refreshController?.refresh()
    }
    
    
    // MARK: - TableViewDataSource Methods
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    
    // MARK: - TableViewDelegate Methods
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }
    
    
    // MARK: - Custom Methods
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = FeedImageCellController(model: cellModel, imageLoader: imageLoader!)
        cellControllers[indexPath] = cellController

        return cellController
    }


    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
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
        indexPaths.forEach(removeCellController)
    }
}
