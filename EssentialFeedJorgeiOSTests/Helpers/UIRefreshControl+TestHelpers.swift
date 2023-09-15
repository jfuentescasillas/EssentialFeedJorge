//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


// MARK: - Extension. UIRefreshControl
extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)        
    }
}
