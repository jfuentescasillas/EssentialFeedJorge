//
//  FeedImageTableViewCell.swift
//  PrototypeJorge
//
//  Created by jfuentescasillas on 11/09/23.
//


import UIKit


class FeedImageTableViewCell: UITableViewCell {
    // MARK: - Elements in Cell
    @IBOutlet private(set) var locationContainer: UIView!
    @IBOutlet private(set) var locationLabel: UILabel!
    @IBOutlet private(set) var feedImageContainer: UIView!
    @IBOutlet private(set) var feedImageView: UIImageView!
    @IBOutlet private(set) var descriptionLabel: UILabel!

    
    // MARK: - Default Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
