//
//  FeedRefreshViewController.swift .swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


final class FeedRefreshViewController: NSObject {
    private let viewModel: FeedViewModel
    private(set) lazy var view: UIRefreshControl = binded(UIRefreshControl())

    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

        
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl{
        viewModel.onChange = { [weak self] viewModel in
            guard let self else { return }
            
            if viewModel.isLoading {
                self.view.beginRefreshing()
            } else {
                self.view.endRefreshing()
            }
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
    
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
}
