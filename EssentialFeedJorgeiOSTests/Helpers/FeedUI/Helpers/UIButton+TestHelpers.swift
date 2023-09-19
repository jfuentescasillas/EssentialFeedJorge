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
        simulate(event: .touchUpInside)        
    }
}
