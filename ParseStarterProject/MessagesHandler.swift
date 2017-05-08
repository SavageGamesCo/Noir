//
//  MessagesHandler.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 5/3/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageReceivedDelegate: class {
    
    func messageReceived(senderID: String, senderName: String, text: String)
    
    
}

class MessagesHandler {
    
    weak var delegate: MessageReceivedDelegate?
    
    private static let _instance = MessagesHandler()
    
    private init(){}
    
    static var Instance: MessagesHandler {
        
        return _instance
    }
    
    func sendMessage(senderID: String, senderName: String, toUser: String, toUserName: String, text: String) {
        
        let data: Dictionary <String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TO_MEMBER_NAME: toUserName, Constants.TO_MEMBER_ID: toUser, Constants.TEXT: text]
        
        Database.Instance.messagesRef.childByAutoId().setValue(data)
        
    }
    
    func sendMedia(image: PFFile?, senderID: String, senderName: String, toUser: String, toUserName: String){
        
        if image != nil {
            let chat = PFObject(className: "Chat")
            
            chat["media"] = image
            chat["senderID"] = senderID
            chat["senderName"] = senderName
            chat["toUser"] = toUser
            chat["toUserName"] = toUserName
            
            chat.saveInBackground { (success, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    
                }
                
            }
        } else {
            print("There was an error sending the image to the database")
        }
    }
    
    func observeMessages(){
        Database.Instance.messagesRef.observe(FIRDataEventType.childAdded) {
            (snapshot: FIRDataSnapshot ) in
            
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.SENDER_ID] as? String {
                    if let senderName = data[Constants.SENDER_NAME] as? String {
                        if let text = data[Constants.TEXT] as? String {
                            self.delegate?.messageReceived(senderID: senderID, senderName: senderName, text: text)
                        }
                    }
                }
            }
            
        }
        
    }
    
}
