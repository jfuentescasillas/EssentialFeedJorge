//
//  FeedRefreshViewController.swift .swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


final class FeedRefreshViewController: NSObject {
    private let presenter: FeedPresenter
    private(set) lazy var view = loadView()

    
    init(presenter: FeedPresenter) {
        self.presenter = presenter
    }

        
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
    
    
    @objc func refresh() {
        presenter.loadFeed()
    }
}


// MARK: - Extension. FeedLoadingViewProtocol
extension FeedRefreshViewController: FeedLoadingViewProtocol {
    func display(isLoading: Bool) {
        if isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}
