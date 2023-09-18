//
//  FeedRefreshViewController.swift .swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


// MARK: - Protocols
protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}


// MARK: - FeedRefreshViewController
final class FeedRefreshViewController: NSObject {
    private let delegate: FeedRefreshViewControllerDelegate
    private(set) lazy var view = loadView()

    
    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }

        
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
    
    
    @objc func refresh() {
        delegate.didRequestFeedRefresh()
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
