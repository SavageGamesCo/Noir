//
//  MemberCell.swift
//  Noir
//
//  Created by Lynx on 2/10/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class MemberCell: BaseCell {
    
    var ProfilePics: UIImageView = {
        var pic = UIImageView()
        pic.image = UIImage(named: "")
        return pic
    }()
    
    var userName: UILabel = {
        var username = UILabel()
        
        username.text = ""
        
        return username
    }()
    
    var userID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupViews() {
        
    }
}
