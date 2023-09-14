//
//  FeedViewController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 12/09/23.
//


import UIKit
import EssentialFeedJorge


// MARK: - FeedViewController Class
final public class FeedViewController: UITableViewController {
    private var loader: FeedLoaderProtocol?
    private var tableModel = [FeedImage]()
    
    
    public convenience init(loader: FeedLoaderProtocol) {
        self.init()
        self.loader = loader
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        load()
    }
    
    
    @objc private func load() {
        refreshControl?.beginRefreshing()

        loader?.load { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(feed):
                self.tableModel = feed
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                
            case .failure: break
            }
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
        
        return cell        
    }
}
