//
//  UIRefreshControl+Helpers.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 10/10/23.
//


import UIKit


extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
