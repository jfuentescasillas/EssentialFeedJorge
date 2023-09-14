//
//  FeedViewController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 12/09/23.
//


import UIKit
import EssentialFeedJorge


public protocol FeedImageDataLoaderProtocol {
    func loadImageData(from url: URL)
    func cancelImageDataLoad(from url: URL)
}


// MARK: - FeedViewController Class
final public class FeedViewController: UITableViewController {
    private var feedLoader: FeedLoaderProtocol?
    private var imageLoader: FeedImageDataLoaderProtocol?
    private var tableModel = [FeedImage]()
    
    
    public convenience init(feedLoader: FeedLoaderProtocol, imageLoader: FeedImageDataLoaderProtocol) {
        self.init()
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        load()
    }
    
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        
        feedLoader?.load { [weak self] result in
            guard let self else { return }
            
            if let feed = try? result.get() {
                self.tableModel = feed
                self.tableView.reloadData()
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageTableViewCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        
        imageLoader?.loadImageData(from: cellModel.url)
        
        return cell
    }
    
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellModel = tableModel[indexPath.row]
        imageLoader?.cancelImageDataLoad(from: cellModel.url)
    }
}
