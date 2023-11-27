//
//  UIView+TestHelpers.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 27/11/23.
//


import UIKit


extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
