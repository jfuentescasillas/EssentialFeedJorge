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

        loader?.load { [weak self] _ in
            guard let self else { return }
            
            self.refreshControl?.endRefreshing()
        }
    }
}
