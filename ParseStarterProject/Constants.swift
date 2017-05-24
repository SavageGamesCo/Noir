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

//COLORS

let ONLINE_COLOR = UIColor(colorLiteralRed: 0.988, green: 0.685, blue: 0.000, alpha: 1.0)
let OFFLINE_COLOR = UIColor(colorLiteralRed: 0.647, green: 0.647, blue: 0.647, alpha: 1.0)
let CHAT_ALERT_COLOR = UIColor(colorLiteralRed: 0.0, green: 255.0, blue: 0.0, alpha: 1.0)
let FAVORITE_BUTTON_COLOR_ON = UIColor(colorLiteralRed: 0.0, green: 255.0, blue: 0.0, alpha: 1.0)
let FAVORITE_BUTTON_COLOR_OFF = UIColor(colorLiteralRed: 197.0, green: 157.0, blue: 108.0, alpha: 1.0)
let CHAT_OUTGOING_COLOR = UIColor(colorLiteralRed: 0.988, green: 0.685, blue: 0.000, alpha: 1.0)
let CHAT_INCOMING_COLOR = UIColor(colorLiteralRed: 0.647, green: 0.647, blue: 0.647, alpha: 1.0)
let CHAT_BACKGROUND_COLOR = UIColor(colorLiteralRed: 0.224, green: 0.224, blue: 0.223, alpha: 1.0)
