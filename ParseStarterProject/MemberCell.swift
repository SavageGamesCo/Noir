//
//  MemberCell.swift
//  Noir
//
//  Created by Lynx on 2/10/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Canvas

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
                
                ProfilePics.image = memberImage
                
            }
            
            if let mEcho = member?.echo {
                echo = mEcho
            }
            
            
            
        }
    }
    
    
    var animationView: CSAnimationView = {
        var animView = CSAnimationView()
        animView.duration = 0.5
        animView.delay = 0
        animView.type = CSAnimationTypePop
        
        return animView
    }()
    
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
    
    var echo = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func animTimer(){
        animationView.startCanvasAnimation()
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = Constants.Colors.NOIR_MEMBER_BORDER_ONLINE
        color.toValue = Constants.Colors.NOIR_MEMBER_BORDER_ECHO
        color.duration = 1
        color.autoreverses = true
        color.repeatCount = .infinity
        color.isRemovedOnCompletion = false
        
        ProfilePics.layer.borderWidth = 3
        ProfilePics.layer.borderColor = Constants.Colors.NOIR_MEMBER_BORDER_ONLINE
        ProfilePics.layer.add(color, forKey: "borderColor")
    }
    override func setupViews() {
        
        addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: animationView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: animationView)
        
        animationView.addSubview(ProfilePics)
        animationView.addSubview(userName)
        
        ProfilePics.translatesAutoresizingMaskIntoConstraints = false
        ProfilePics.layer.borderWidth = 3
        ProfilePics.layer.cornerRadius = self.frame.width / 2
        
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.addConstraintsWithFormat(format: "H:|[v0(\(self.frame.width))]", views: ProfilePics)
        animationView.addConstraintsWithFormat(format: "V:|[v0(\(self.frame.width))]|", views: ProfilePics)
        
        animationView.addConstraintsWithFormat(format: "H:|[v0]|", views: userName)
        animationView.addConstraintsWithFormat(format: "V:[v0]-10-[v1]|", views:ProfilePics, userName)
        
        if !echo {

        } else {
            
            var timer: Timer!
            
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(animTimer), userInfo: nil, repeats: true)

            animTimer()
        }
        
    }
    
    
}
