//
//  MessagesHandler.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 5/3/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import Parse

protocol MessageReceivedDelegate: class {
    
    func messageReceived(senderID: String, text: String, messageID: String)
    
    
}

class MessagesHandler {
    
    weak var delegate: MessageReceivedDelegate?
    
    private static let _instance = MessagesHandler()
    
    private init(){}
    
    static var Instance: MessagesHandler {
        
        return _instance
    }
    
    func sendMessage(senderID: String, senderName: String, toUser: String, toUserName: String, text: String) {
        
        let chat = PFObject(className: "Chat")
        
        chat["senderID"] = senderID
        chat["senderName"] = senderName
        chat["text"] = text
        chat["url"] = ""
        chat["toUser"] = toUser
        chat["toUserName"] = toUserName
        
        
        //let chatData : Dictionary<String, Any> = ["senderId": senderID, "senderName": senderName, "text": text]
        
        chat.saveInBackground { (success, error) in
            
            if error != nil {
                print(error)
            } else {
                
            }
            
        }
        
    }
    
    func sendMedia(image: PFFile?, senderID: String, senderName: String, toUser: String, toUserName: String){
        
        if image != nil {
            let chat = PFObject(className: "Chat")
            
            chat["media"] = image
            chat["senderID"] = senderID
            chat["senderName"] = senderName
            chat["toUser"] = toUser
            chat["toUserName"] = toUserName
        } else {
            print("There was an error sending the image to the database")
        }
    }
    
    func observeMessages(){
        let chat = PFObject(className: "Chat")
        
        if let senderID = chat["senderID"] as? String {
            if let text = chat["text"] as? String {
                if let messageID = chat.objectId {
                    self.delegate?.messageReceived(senderID: senderID, text: text, messageID: messageID)
                }
            }
        }
        
    }
    
}
