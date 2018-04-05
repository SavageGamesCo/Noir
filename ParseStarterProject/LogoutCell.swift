//
//  LogoutCell.swift
//  Noir
//
//  Created by Lynx on 3/16/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class logoutCell: BaseCell {
    
    let logoutLabel: UILabel = {
        let label = UILabel()
        label.text = "Logout"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func setupViews() {
        
        addSubview(logoutLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: logoutLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: logoutLabel)
        
    }
}
