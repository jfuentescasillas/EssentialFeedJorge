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
    // MARK: - Elements in Storyboard
    @IBOutlet private var view: UIRefreshControl?
    
    // MARK: - Properties
    var delegate: FeedRefreshViewControllerDelegate?

    
    // MARK: - Action methods
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
}


// MARK: - Extension. FeedLoadingViewProtocol
extension FeedRefreshViewController: FeedLoadingViewProtocol {
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
}
