//
//  UsersCollectionViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var ProfilePics: UIImageView!
    @IBOutlet var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var userID = ""
    
    

}
