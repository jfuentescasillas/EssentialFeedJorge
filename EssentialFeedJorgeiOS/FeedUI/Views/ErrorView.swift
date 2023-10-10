//
//  ErrorView.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 10/10/23.
//


import UIKit


// MARK: - Error View Class
public final class ErrorView: UIView {
    @IBOutlet private var label: UILabel!
    
    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        label.text = nil
    }
}
