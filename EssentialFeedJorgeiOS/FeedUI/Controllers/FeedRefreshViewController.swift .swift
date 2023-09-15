//
//  FeedRefreshViewController.swift .swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit
import EssentialFeedJorge


final class FeedRefreshViewController: NSObject {
    private let feedLoader: FeedLoaderProtocol
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return view
    }()

    
    init(feedLoader: FeedLoaderProtocol) {
        self.feedLoader = feedLoader
    }

    
    var onRefresh: (([FeedImage]) -> Void)?

    
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            
            self?.view.endRefreshing()
        }
    }
}
