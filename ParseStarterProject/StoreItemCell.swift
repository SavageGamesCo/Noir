//
//  StoreItemCell.swift
//  Noir
//
//  Created by Lynx on 3/29/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
//import SwiftyStoreKit

class StoreItemCell: BaseCell {
    
    var itemTextField: UILabel = {
        let textField = UILabel()
        textField.textColor = Constants.Colors.NOIR_YELLOW
       
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.numberOfLines = 0
        return textField
    }()
    
    var purchaseButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        
        button.backgroundColor = Constants.Colors.NOIR_YELLOW
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        button.tintColor = Constants.Colors.NOIR_WHITE
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.sizeToFit()
        
        return button
    }()
    
    var titleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = Constants.Colors.NOIR_YELLOW
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var priceLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = Constants.Colors.NOIR_YELLOW
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = Constants.Colors.NOIR_RED_MEDIUM
        
        setupDescription()
        
    }
    
    func setupDescription() {
        
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(purchaseButton)
        addSubview(itemTextField)
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-5-[v1]-5-[v2(135)]-10-|", views: titleLabel, priceLabel, purchaseButton )
        
        addConstraintsWithFormat(format: "V:|-10-[v0]", views: titleLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0]", views: priceLabel )
        addConstraintsWithFormat(format: "V:|-10-[v0]", views: purchaseButton )
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: itemTextField )
        addConstraintsWithFormat(format: "V:[v0]-5-|", views: itemTextField )
        
        purchaseButton.isUserInteractionEnabled = true
        purchaseButton.isEnabled = true
        
        
        
        
    }
    
}
