//
//  GalleryCell.swift
//  Noir
//
//  Created by Lynx on 2/28/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class GalleryCell: BaseCell {

    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .clear
        
        addSubview(iconImageView)
        addSubview(nameLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: iconImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: iconImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(50)]|", views: nameLabel)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Constants.Colors.NOIR_BLACK.withAlphaComponent(0.9) : Constants.Colors.NOIR_BLACK.withAlphaComponent(0.9)
            nameLabel.textColor = isHighlighted ? Constants.Colors.NOIR_YELLOW : Constants.Colors.NOIR_YELLOW
            iconImageView.tintColor = isHighlighted ? Constants.Colors.NOIR_YELLOW : Constants.Colors.NOIR_YELLOW
        }
    }
    
    var galleryImage: GalleryImage? {
        didSet {
            nameLabel.text = galleryImage?.name
            
            if let imageName = galleryImage?.image {
                iconImageView.image = imageName.withRenderingMode(.alwaysTemplate)
//                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.text = "Setting"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = Constants.Colors.NOIR_YELLOW
        label.backgroundColor = Constants.Colors.NOIR_RED_DARK.withAlphaComponent(0.9)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
//        imageView.tintColor = Constants.Colors.NOIR_TINT
        
        return imageView
    }()
    
}
