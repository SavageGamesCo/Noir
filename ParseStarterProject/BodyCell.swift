//
//  BodyCell.swift
//  Noir
//
//  Created by Lynx on 3/16/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class bodyCell: BaseCell {
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Body Type:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bodyField: UITextField = {
        let textField = UITextField()
        //        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["body"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let bodyStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
        
        setupStats(stack: bodyStack, statLabel: bodyLabel, statField: bodyField)
        
    }
    
}
