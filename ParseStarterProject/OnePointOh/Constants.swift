//
//  Constants.swift
//  Noir
//
//  Created by Lynx on 5/14/17.
//  Copyright © 2017 Savage Code. All rights reserved.
//

import Foundation
import UIKit
import Parse

//HELPER VARIABLES

let APPLICATION = "noir"
let CURRENT_USER = PFUser.current()?.objectId!
let CURRENT_USERNAME = PFUser.current()?.username!

//Echo Helpers
let WithinArea = 11.0

//COLORS

let ONLINE_COLOR = Constants.Colors.NOIR_BLACK
let ONLINE_COLOR_2 = Constants.Colors.NOIR_BLACK
let OFFLINE_COLOR = Constants.Colors.NOIR_BLACK
let CHAT_ALERT_COLOR = Constants.Colors.NOIR_BLACK
let FAVORITE_BUTTON_COLOR_ON = Constants.Colors.NOIR_BLACK
let FAVORITE_BUTTON_COLOR_OFF = Constants.Colors.NOIR_BLACK
let CHAT_OUTGOING_COLOR = Constants.Colors.NOIR_BLACK
let CHAT_INCOMING_COLOR = Constants.Colors.NOIR_BLACK
let CHAT_BACKGROUND_COLOR = Constants.Colors.NOIR_BLACK

//FONT
let SYSTEM_FONT = UIFont.boldSystemFont(ofSize: 12)

//SOUNDS
let SYSTEM_SOUND = 1016
