//
//  AboutCell.swift
//  Noir
//
//  Created by Lynx on 3/16/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class aboutCell: BaseCell {
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.sizeToFit()
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aboutField: UITextField = {
        let textField = UITextField()
        //        textField.backgroundColor = Constants.Colors.NOIR_RED_MEDIUM
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["about"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let aboutStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
        
        setupStats(stack: aboutStack, statLabel: aboutLabel, statField: aboutField)
        addConstraintsWithFormat(format: "H:|[v0]|", views: aboutStack)
        aboutStack.addConstraintsWithFormat(format: "V:|[v0(35)]", views: aboutLabel)
        aboutStack.addConstraintsWithFormat(format: "H:|-10-[v0]-5-[v1(330)]-10-|", views: aboutLabel, aboutField)
        aboutField.textAlignment = .left
        aboutField.contentVerticalAlignment = .top
        
    }
}
