//
//  MessagesHandler.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 5/3/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

protocol MessageReceivedDelegate: class {
    
    func messageReceived(senderID: String, senderName: String, text: String)
    
    func mediaMessageReceived(senderID: String, senderName: String, url: String)
    
    
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
    
    func sendMedia(image: Data?, video: URL?, senderID: String, senderName: String, toUser: String, toUserName: String){
        
        if image != nil {
            Database.Instance.imageStorageRef.child(senderID + "\(NSUUID().uuidString).jpg").put(image!, metadata: nil){
                (metadata: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    print("there was a problem uploading image")
                } else {
                    
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, toUser: toUser, toUserName: toUserName, url: String(describing: metadata!.downloadURL()!))
                    
                }
                
                
            }
        } else {
            Database.Instance.videoStorageRef.child(senderID + "\(NSUUID().uuidString)").putFile(video!, metadata: nil){
                (metadata: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    print("there was a problem uploading image")
                } else {
                    
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, toUser: toUser, toUserName: toUserName, url: String(describing: metadata!.downloadURL()!))
                    
                }
                
                
            }

        }
    }
    
    func sendMediaMessage(senderID: String, senderName: String, toUser: String, toUserName: String, url: String){
        
       let data: Dictionary <String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TO_MEMBER_NAME: toUserName, Constants.TO_MEMBER_ID: toUser, Constants.URL: url]
        
        Database.Instance.mediaMessagesRef.childByAutoId().setValue(data)
        
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
    
    func observeMediaMessages(){
        Database.Instance.mediaMessagesRef.observe(FIRDataEventType.childAdded) {
            (snapshot: FIRDataSnapshot ) in
            
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.SENDER_ID] as? String {
                    if let senderName = data[Constants.SENDER_NAME] as? String {
                        if let fileURL = data[Constants.URL] as? String {
                            self.delegate?.mediaMessageReceived(senderID: senderID, senderName: senderName, url: fileURL)
                        }
                    }
                    
                }
            }
        }
    }
}
