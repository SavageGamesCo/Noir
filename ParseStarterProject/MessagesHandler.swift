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
    
    func messageReceived(senderID: String, text: String)
    
    
}

class MessagesHandler {
    
    weak var delegate: MessageReceivedDelegate?
    
    private static let _instance = MessagesHandler()
    
    private init(){}
    
    static var Instance: MessagesHandler {
        
        return _instance
    }
    
    func sendMessage(senderID: String, senderName: String, to: String, text: String) {
        
        let chat = PFObject(className: "Chat")
        
        chat["senderID"] = senderID
        chat["senderName"] = senderName
        chat["text"] = text
        chat["url"] = ""
        chat["toUser"] = to
        
        
        //let chatData : Dictionary<String, Any> = ["senderId": senderID, "senderName": senderName, "text": text]
        
        chat.saveInBackground { (success, error) in
            
            if error != nil {
                print(error)
            } else {
                
            }
            
        }
        
    }
    
    func observeMessages(){
        let chat = PFObject(className: "Chat")
        
        if let senderID = chat["senderID"] as? String {
            if let text = chat["text"] as? String {
                self.delegate?.messageReceived(senderID: senderID, text: text)
            }
        }
        
    }
    
}
