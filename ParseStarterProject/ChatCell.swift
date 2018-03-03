//
//  ChatCell.swift
//  Noir
//
//  Created by Lynx on 3/2/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class ChatCell: BaseCell {
    let messageView = UIView()
    var labelSide = String()
    var message: Message? {
        didSet{
            
            if message?.fromID == PFUser.current()?.objectId {
                
                messageText.textAlignment = .right
                messageText.backgroundColor = Constants.Colors.NOIR_CHAT_BUBBLE_SENT
                messageText.textColor = Constants.Colors.NOIR_CHAT_BUBBLE_SENT_TEXT
                
                
                
            } else {
                messageText.textAlignment = .left
                messageText.backgroundColor = Constants.Colors.NOIR_CHAT_BUBBLE_RECIEVED
                messageText.textColor = Constants.Colors.NOIR_CHAT_BUBBLE_RECIEVED_TEXT
                
          
                
            }
            
            messageText.text = message?.text
            if let date = message?.date {
                
                let dateFormatter = DateFormatter ()
                
                dateFormatter.dateFormat = "MMM d, h:mm a"
                
                timeLabel.text = dateFormatter.string(from: date as Date)
                
            }
          
        }
    }
    
    var messageText: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_DARK_TEXT
        label.backgroundColor = .blue
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        label.sizeToFit()
        label.textContainerInset.top = 5
        label.textContainerInset.bottom = 5
        label.textContainerInset.left = 8
        label.textContainerInset.right = 8
        label.isEditable = false
        label.isScrollEnabled = false
        
        
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = Constants.Colors.NOIR_DARK_TEXT
        label.textAlignment = .center
        
        
        return label
    }()
    
    override func setupViews() {
        
        
        addSubview(messageText)
        addSubview(timeLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: timeLabel)
        addConstraintsWithFormat(format: "V:|[v0]", views: timeLabel)
        
        addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: messageText)
        addConstraintsWithFormat(format: "V:|-15-[v0]-5-|", views: messageText)
        
        
    }
    
}
