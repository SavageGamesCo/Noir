//
//  Database.swift
//  Noir
//
//  Created by Lynx on 5/8/17.
//  Copyright © 2017 Savage Code. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


protocol FetchData: class {
    
    func dataReceived(members: [Member])
    
}

class Database {

    private static let _instance = Database()
    
    weak var delegate: FetchData?
    
    private init(){}
    
    static var Instance: Database {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        
        return FIRDatabase.database().reference()
        
    }
    
    var usersRef: FIRDatabaseReference {
        
        return dbRef.child(Constants.USERS)
    }
    
    var messagesRef: FIRDatabaseReference {
        
        return dbRef.child(Constants.MESSAGES)
    }
    
    var mediaMessagesRef: FIRDatabaseReference {
        
        return dbRef.child(Constants.MEDIA_MESSAGES)
    }
    
    var storageRef: FIRStorageReference {
        
        return FIRStorage.storage().reference(forURL: "gs://noir-analytics.appspot.com")
        
    }
    
    var imageStorageRef: FIRStorageReference {
        
        return storageRef.child(Constants.IMG_STORAGE)
        
    }
    
    var videoStorageRef: FIRStorageReference {
        
        return storageRef.child(Constants.VID_STORAGE)
        
    }
    
    func saveUser(withID: String, email: String, password: String, username: String) {
        
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.USERNAME: username, Constants.AGE: "", Constants.BODY: "", Constants.ETHNICITY: "", Constants.ABOUT: "", Constants.FAVORITE: [""], Constants.FLIRT: [""], Constants.MARITAL: "", Constants.LOCATION: [""] ,Constants.FLIRT_LIMIT: 25, Constants.FAVORITE_LIMIT: 25, Constants.GLOBAL_LIMIT: 100, Constants.LOCAL_LIMIT: 25, Constants.AD_FREE: false, Constants.ONLINE: false ]
        
        
        usersRef.child(withID).setValue(data)
        
        
    }
    
    func getMembers(){
        
        
        usersRef.observeSingleEvent(of: FIRDataEventType.value){
            (snapshot: FIRDataSnapshot) in
            
            var membersArray = [Member]()
            
            if let members = snapshot.value as? NSDictionary{
                for (key, value) in members {
                    if let memberData = value as? NSDictionary {
                        if let username = memberData[Constants.USERNAME] as? String {
                            let id = key as! String
                            let newMember = Member(id: id, name: username, pic: "", age: "", height: "", weight: "", ethnicity: "", marital: "", location: "", about: "")
                            
                            membersArray.append(newMember)
                            
                        }
                    }
                }
            }
            print(membersArray)
            self.delegate?.dataReceived(members: membersArray)
            
        }
        
    }
    
    
    
    
}//class
