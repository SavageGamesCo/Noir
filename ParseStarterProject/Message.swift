//
//  Message.swift
//  Noir
//
//  Created by Lynx on 2/21/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class Sender: NSObject {
    
    var name: String?
    var userID: String?
    var profileImage: UIImage?
    var messages: [Message]?
    
}

class Message: NSObject {
    
    var text: String?
    var date: Date?
    var toID: String?
    var fromID: String?
    var sender: Sender?
    var readMessage: Bool?
    var messageID: String?
    var mediaMessage: UIImage?
    
}
