//
//  HeightCell.swift
//  Noir
//
//  Created by Lynx on 3/16/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class heightCell: BaseCell {
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heightField: UITextField = {
        let textField = UITextField()
        //        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["height"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let heightStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
        
        setupStats(stack: heightStack, statLabel: heightLabel, statField: heightField)
        
    }
    
    
}
