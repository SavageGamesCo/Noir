//
//  DeleteCell.swift
//  Noir
//
//  Created by Lynx on 3/16/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class deleteCell: BaseCell {
    
    let deleteLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Delete Account"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override func setupViews() {
        
        addSubview(deleteLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: deleteLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: deleteLabel)
        
    }
}
