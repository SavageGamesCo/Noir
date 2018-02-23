//
//  MemberCell.swift
//  Noir
//
//  Created by Lynx on 2/10/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit


class MemberCell: BaseCell {
    
    var member: Member? {
        didSet {
            if let memberName = member?.memberName {
                userName.text = memberName
            }
            if let memberID = member?.memberID {
               userID = memberID
            }
            
            if let blockedMember = member?.blocked {
                blocked = blockedMember
            }
            if let memberImage = member?.memberImage {
                DispatchQueue.main.async {
                    self.ProfilePics.image = memberImage
                }
                
            }
            
            
        }
    }
    
    var ProfilePics: UIImageView = {
        var pic = UIImageView()
        pic.image = UIImage(named: "default_user_image")
        pic.contentMode = .scaleAspectFill
        pic.clipsToBounds = true
    
//        pic.backgroundColor = Constants.Colors.NOIR_GREY_DARK
        
        return pic
    }()
    
    
    
    var userName: UILabel = {
        var username = UILabel()
        
        username.text = "Member Name"
        username.textAlignment = .center
        username.font = UIFont.systemFont(ofSize: 12)
        username.numberOfLines = 2
        username.heightAnchor.constraint(equalToConstant: 24)
        username.textColor = Constants.Colors.NOIR_MEMBER_TEXT
        return username
    }()
    
    var userID: String?
    
    var blocked: Bool?
    
    var online: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupViews() {
        
        addSubview(ProfilePics)
        addSubview(userName)

        ProfilePics.translatesAutoresizingMaskIntoConstraints = false
        ProfilePics.layer.borderWidth = 3
        ProfilePics.layer.borderColor = Constants.Colors.NOIR_MEMBER_BORDER_ONLINE
        ProfilePics.layer.cornerRadius = self.frame.width / 2
        
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat(format: "H:|[v0(\(self.frame.width))]", views: ProfilePics)
        addConstraintsWithFormat(format: "V:|[v0(\(self.frame.width))]|", views: ProfilePics)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: userName)
        addConstraintsWithFormat(format: "V:[v0]-10-[v1]|", views:ProfilePics, userName)
        
        
        
    }
    
    
}
