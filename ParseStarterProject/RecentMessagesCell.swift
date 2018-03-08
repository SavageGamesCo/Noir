//
//  RecentMessagesController.swift
//  Noir
//
//  Created by Lynx on 2/21/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class RecentMessagesCell: BaseCell {
    
    var message: Message? {
        didSet{
            nameLabel.text = message?.sender?.name
            
            if message?.text != nil {
               messageLabel.text = message?.text
            } else {
                messageLabel.text = "Image Received..."
            }
            
            
            if let date = message?.date {
                
                let dateFormatter = DateFormatter ()
                
                dateFormatter.dateFormat = "MMM d, h:mm a"
                
                dateTimeLabel.text = dateFormatter.string(from: date as Date)
//                dateTimeLabel.text = date
                
            }
            if message?.readMessage == false || message?.readMessage == nil {
                message?.readMessage = false
                self.hasRead.alpha = 0.5
            } else {
                self.hasRead.alpha = 1.0
            }
            
            profileImageview.image = message?.sender?.profileImage
            hasRead.image = message?.sender?.profileImage
            
        }
    }
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.NOIR_RECENT_MESSAGES_DIVIDER
        
        return view
        
    }()
    
    let profileImageview: UIImageView = {
        let pic = UIImageView()
        pic.contentMode = .scaleAspectFill
        pic.layer.cornerRadius = 34
        pic.layer.masksToBounds = true
        
        return pic
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Member Name"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Constants.Colors.NOIR_RECENT_MESSAGES_NAME
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Example of the most recent message I got from this member."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_RECENT_MESSAGES_MESSAGE
        
        return label
    }()
    
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Feb 12 2018"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Constants.Colors.NOIR_RECENT_MESSAGES_DATE
        label.textAlignment = .right
        
        return label
    }()
    
    let hasRead: UIImageView = {
        let pic = UIImageView()
        pic.contentMode = .scaleAspectFill
        pic.layer.cornerRadius = 10
        pic.layer.masksToBounds = true
        
        return pic
    }()
    
    override func setupViews() {
//        backgroundColor = .blue
        
        addSubview(profileImageview)
        addSubview(dividerLine)
        
        setupContainer()
        
        profileImageview.translatesAutoresizingMaskIntoConstraints = false
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageview.image = UIImage(named: "default_user_image")
        profileImageview.layer.cornerRadius = 34
        profileImageview.layer.borderColor = Constants.Colors.NOIR_MEMBER_BORDER_ONLINE
        profileImageview.layer.borderWidth = 3
        
        addConstraintsWithFormat(format: "H:|-14-[v0(68)]", views: profileImageview)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageview)
        addConstraint(NSLayoutConstraint(item: profileImageview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLine)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLine)
    }
    
    private func setupContainer() {
        let container = UIView()
//        container.backgroundColor = .red
        
        addSubview(container)
        container.addSubview(nameLabel)
        container.addSubview(messageLabel)
        container.addSubview(dateTimeLabel)
        container.addSubview(hasRead)
        
        hasRead.image = UIImage(named: "default_user_image")
        
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: container)
        addConstraintsWithFormat(format: "V:[v0(60)]", views: container)
        addConstraint(NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        container.addConstraintsWithFormat(format: "H:|[v0][v1]-12-|", views: nameLabel, dateTimeLabel)
        container.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        
        container.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasRead)
        
        container.addConstraintsWithFormat(format: "V:|[v0(24)]", views: dateTimeLabel)
        
        container.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasRead)
        
        
        
    }
    
   
}
