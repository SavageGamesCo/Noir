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
    
    var chatLogController: ChatController?
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
            
            if message?.mediaMessage != nil {
                mediaMessage.alpha = 1
                mediaMessage.image = message?.mediaMessage
            } else {
                mediaMessage.alpha = 0
                mediaMessage.removeFromSuperview()
                messageText.text = message?.text
            }
            
            
            
            if let date = message?.date {
                
                let dateFormatter = DateFormatter ()
                
                dateFormatter.dateFormat = "MMM d YYYY, h:mm a"
                
                timeLabel.text = dateFormatter.string(from: date as Date)
                
            }
          
        }
    }
    
    var messageText: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
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
        label.textColor = Constants.Colors.NOIR_LIGHT_TEXT
        label.textAlignment = .center
        
        
        return label
    }()
    
    lazy var mediaMessage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap) ))
        
        return imageView
    }()
    
    @objc func handleImageTap(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
           self.chatLogController?.performZoomForStartingImageView(startingImageView: imageView)
        }
        
    }
    
    override func setupViews() {
        
        
        addSubview(messageText)
        addSubview(timeLabel)
        addSubview(mediaMessage)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: timeLabel)
        addConstraintsWithFormat(format: "V:|[v0]", views: timeLabel)
        
        addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: messageText)
        addConstraintsWithFormat(format: "V:|-15-[v0]-5-|", views: messageText)
        
        addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: mediaMessage)
        addConstraintsWithFormat(format: "V:|-15-[v0]-5-|", views: mediaMessage)
        
        
    }
    
}
