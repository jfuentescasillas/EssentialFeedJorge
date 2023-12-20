//
//  ImageCommentCellController.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 17/12/23.
//


import UIKit
import EssentialFeedJorge


public class ImageCommentCellController: CellControllerProtocol {
    private let model: ImageCommentViewModel
    
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.usernameLabel.text = model.username
        cell.dateLabel.text = model.date
        
        return cell
    }
    

    public func preload() {
        
    }
    
    
    public func cancelLoad() {
        
    }
}
