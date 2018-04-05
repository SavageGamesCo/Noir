//
//  ProfileImageCell.swift
//  Noir
//
//  Created by Lynx on 3/16/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class profImageCell: BaseCell {
    
    let mainProfileImage: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func setupViews() {
        backgroundColor = .blue
        
        addSubview(mainProfileImage)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainProfileImage)
        addConstraintsWithFormat(format: "V:|[v0]|", views: mainProfileImage)
        
    }
    
}
