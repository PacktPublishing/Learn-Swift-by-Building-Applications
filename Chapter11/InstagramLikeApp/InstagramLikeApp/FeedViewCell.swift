//
//  FeedViewCell.swift
//  InstagramFeedNativeDemo
//
//  Created by Emil Atanasov on 11.01.18.
//  Copyright © 2018 SwiftFMI. All rights reserved.
//

import UIKit

protocol ProfileHandler {
    func openProfile(cell: UICollectionViewCell)
}

class FeedViewCell: UICollectionViewCell {
    var tapGestureRecogniser: UITapGestureRecognizer!
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
        
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(onProfileTap))
        avatarName.superview?.addGestureRecognizer(tapGestureRecogniser)
    }
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarName: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageWidthConstraint: NSLayoutConstraint!
    
    var delegate: ProfileHandler?
    
    @objc func onProfileTap(sender: Any) {
        delegate?.openProfile(cell: self)
    }
    var imageDimentions: CGSize = .zero {
        didSet {
                let imageWidth = UIScreen.main.bounds.width
                let scaleRatio = imageDimentions.width/imageWidth
                let scaledHeigth = imageDimentions.height/scaleRatio
            
                imageWidthConstraint.constant = imageWidth
                imageHeightConstraint.constant = scaledHeigth
            
        }
    }
    
}
