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
    
    
    // MARK: - Custom Methods
    public func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil
        
        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil
        
        feedImageView.image = UIImage(named: model.imageName)
    }
}
