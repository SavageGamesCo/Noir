//
//  MemberCellEcho.swift
//  Noir
//
//  Created by Lynx on 3/5/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//


import UIKit


class MemberCellEcho: BaseCell {
    var userID: String?
    
    var blocked: Bool?
    
    var online: Bool?
    
    var echo: Bool?
    
    var member: Member? {
        didSet {
            
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
    
    var profileContainer: UIView = {
        var view = UIView()
        
        return view
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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupViews() {
        
        
        //        addSubview(ProfilePics)
        addSubview(profileContainer)
        profileContainer.addSubview(ProfilePics)
        
        addSubview(userName)
        
        if online != nil && online! {
            let position = CGPoint(x: self.center.x, y: self.center.y - (self.frame.height / 4) )
            let pulse = Pulse(numberOfPulses: 1, radius: 50, position: position)
            pulse.radius = 50
            pulse.position = position
            pulse.animationDuration = 1.0
            pulse.numberOfPulses = Float(CGFloat.infinity)
            
            ProfilePics.layer.borderColor = Constants.Colors.NOIR_MEMBER_BORDER_ECHO
            
            profileContainer.layer.insertSublayer(pulse, below: ProfilePics.layer)
            ProfilePics.translatesAutoresizingMaskIntoConstraints = false
            ProfilePics.layer.borderWidth = 3
            ProfilePics.layer.cornerRadius = self.frame.width / 2
            
            
            userName.translatesAutoresizingMaskIntoConstraints = false
            
            addConstraintsWithFormat(format: "H:|[v0(\(self.frame.width))]", views: ProfilePics)
            addConstraintsWithFormat(format: "V:|[v0(\(self.frame.width))]|", views: ProfilePics)
            addConstraintsWithFormat(format: "H:|[v0(\(self.frame.width))]", views: profileContainer)
            addConstraintsWithFormat(format: "V:|[v0(\(self.frame.width))]|", views: profileContainer)
            
            addConstraintsWithFormat(format: "H:|[v0]|", views: userName)
            addConstraintsWithFormat(format: "V:[v0]-10-[v1]|", views:profileContainer, userName)
            
        } else {
            ProfilePics.layer.borderColor = Constants.Colors.NOIR_MEMBER_BORDER_OFFLINE
            ProfilePics.translatesAutoresizingMaskIntoConstraints = false
            ProfilePics.layer.borderWidth = 3
            ProfilePics.layer.cornerRadius = self.frame.width / 2
            
            
            userName.translatesAutoresizingMaskIntoConstraints = false
            
            addConstraintsWithFormat(format: "H:|[v0(\(self.frame.width))]", views: ProfilePics)
            addConstraintsWithFormat(format: "V:|[v0(\(self.frame.width))]|", views: ProfilePics)
            addConstraintsWithFormat(format: "H:|[v0(\(self.frame.width))]", views: profileContainer)
            addConstraintsWithFormat(format: "V:|[v0(\(self.frame.width))]|", views: profileContainer)
            
            addConstraintsWithFormat(format: "H:|[v0]|", views: userName)
            addConstraintsWithFormat(format: "V:[v0]-10-[v1]|", views:profileContainer, userName)
        }
        
        
        
        
    }
    
    
}

