//
//  SettingCell.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class DetailCell: BaseCell {
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = Constants.Colors.NOIR_RED_DARK
        
        addSubview(nameLabel)
        addSubview(nameLabelDetail)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(100)]-8-[v1]|", views: nameLabel, nameLabelDetail)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabelDetail)
        
//        addConstraint(NSLayoutConstraint(item: nameLabelDetail, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Constants.Colors.NOIR_GREY_MEDIUM : Constants.Colors.NOIR_RED_DARK
            nameLabel.textColor = isHighlighted ? Constants.Colors.NOIR_WHITE : Constants.Colors.NOIR_YELLOW
            nameLabelDetail.textColor = isHighlighted ? Constants.Colors.NOIR_WHITE : Constants.Colors.NOIR_YELLOW
            iconImageView.tintColor = isHighlighted ? Constants.Colors.NOIR_WHITE : Constants.Colors.NOIR_YELLOW
        }
    }
    
    var detail: Detail? {
        didSet {
            nameLabel.text = detail?.label
            
            nameLabelDetail.text = detail?.detail
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = Constants.Colors.NOIR_YELLOW
        return label
    }()
    
    let nameLabelDetail: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 12
        
        //        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.sizeToFit()
        
        label.textColor = Constants.Colors.NOIR_YELLOW
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

