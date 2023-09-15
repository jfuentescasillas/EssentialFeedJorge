//
//  UIButton+TestHelpers.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit


// MARK: - Extension. UIButton
extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
