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
        
//        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: iconImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Constants.Colors.NOIR_GREY_MEDIUM : Constants.Colors.NOIR_WHITE
            nameLabel.textColor = isHighlighted ? Constants.Colors.NOIR_WHITE : Constants.Colors.NOIR_GREY_DARK
            iconImageView.tintColor = isHighlighted ? Constants.Colors.NOIR_WHITE : Constants.Colors.NOIR_GREY_DARK
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
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Constants.Colors.NOIR_GREY_DARK
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
//        imageView.tintColor = Constants.Colors.NOIR_TINT
        
        return imageView
    }()
    
    
}
