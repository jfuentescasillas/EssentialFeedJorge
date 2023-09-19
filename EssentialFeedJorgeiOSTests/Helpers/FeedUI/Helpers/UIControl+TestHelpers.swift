//
//  UIControl+TestHelpers.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


// MARK: - Extension. UIControl
extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
