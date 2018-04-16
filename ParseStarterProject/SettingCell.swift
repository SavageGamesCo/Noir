//
//  SettingCell.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = Constants.Colors.NOIR_WHITE
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(20)]-8-[v1]|", views: iconImageView, nameLabel)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:[v0(20)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Constants.Colors.NOIR_RED_DARK : Constants.Colors.NOIR_WHITE
            nameLabel.textColor = isHighlighted ? Constants.Colors.NOIR_WHITE : Constants.Colors.NOIR_GREY_DARK
            iconImageView.tintColor = isHighlighted ? Constants.Colors.NOIR_WHITE : Constants.Colors.NOIR_GREY_DARK
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
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
        imageView.tintColor = Constants.Colors.NOIR_TINT
        
        return imageView
    }()
    

}
