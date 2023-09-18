//
//  FeedRefreshViewController.swift .swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


final class FeedRefreshViewController: NSObject {
    private let loadFeed: () -> Void
    private(set) lazy var view = loadView()

    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }

        
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
    
    
    @objc func refresh() {
        loadFeed()
    }
}


// MARK: - Extension. FeedLoadingViewProtocol
extension FeedRefreshViewController: FeedLoadingViewProtocol {
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}
