//
//  UITableView+Dequeueing.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 18/09/23.
//


import UIKit


// MARK: - Extension. UITableView
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
