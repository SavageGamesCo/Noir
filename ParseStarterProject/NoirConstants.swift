//
//  Constants.swift
//  Noir
//
//  Created by Lynx on 2/9/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Colors {
        //Base layout Colors
        static let NOIR_BLACK = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1)
        static let NOIR_WHITE = UIColor.init(white: 0.9, alpha: 1)
        static let NOIR_GREY_DARK = UIColor.rgb(red: 44, green: 53, blue: 57, alpha: 1)
        static let NOIR_GREY_MEDIUM = UIColor.rgb(red: 87, green: 102, blue: 111, alpha: 1)
        static let NOIR_GREY_LIGHT = UIColor.rgb(red: 194, green: 197, blue: 186, alpha: 1)
        static let NOIR_DARK_LINE = UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        static let NOIR_YELLOW = UIColor.rgb(red: 242, green: 171, blue: 31, alpha: 1)
        static let NOIR_GREEN = UIColor.rgb(red: 45, green: 150, blue: 43, alpha: 1)
        static let NOIR_ORANGE = UIColor.rgb(red: 255, green: 76, blue: 0, alpha: 1)
        static let NOIR_PURPLE_LIGHT = UIColor.rgb(red: 153, green: 102, blue: 166, alpha: 1)
        static let NOIR_PURPLE_MEDIUM = UIColor.rgb(red: 112, green: 14, blue: 137, alpha: 1)
        static let NOIR_PURPLE_DARK = UIColor.rgb(red: 64, green: 0, blue: 80, alpha: 1)
        
        static let NOIR_CG_ORANGE = CGColor(colorLiteralRed: 255/255, green: 76/255, blue: 0/255, alpha: 1)
        static let NOIR_CG_YELLOW = CGColor(colorLiteralRed: 242/255, green: 171/255, blue: 31/255, alpha: 1)
        
        static let NOIR_RED_DARK = UIColor.rgb(red: 58, green: 0, blue: 0, alpha: 1)
        static let NOIR_RED_LIGHT = UIColor.rgb(red: 156, green: 3, blue: 4, alpha: 1)
        static let NOIR_RED_MEDIUM = UIColor.rgb(red: 94, green: 4, blue: 9, alpha: 1)
        
        
        //Text Colors
        static let NOIR_LIGHT_TEXT = UIColor.init(white: 0.9, alpha: 1)
        static let NOIR_DARK_TEXT = UIColor.rgb(red: 51 , green: 48 , blue: 53, alpha: 1)
        static let NOIR_NAV_BAR_TEXT = NOIR_YELLOW
        static let NOIR_BUTTON_TEXT = NOIR_BLACK
        static let NOIR_MEMBER_TEXT = NOIR_YELLOW
        static let NOIR_CHAT_BUBBLE_SENT_TEXT = NOIR_BLACK
        static let NOIR_CHAT_BUBBLE_RECIEVED_TEXT = NOIR_BLACK
        static let NOIR_RECENT_MESSAGES_NAME = NOIR_YELLOW
        static let NOIR_RECENT_MESSAGES_MESSAGE = NOIR_YELLOW
        static let NOIR_RECENT_MESSAGES_DATE = NOIR_YELLOW
        
        //Button colors
        static let NOIR_BUTTON_SELECTED = UIColor.init(white: 0.9, alpha: 1)
        static let NOIR_BUTTON_NORMAL = UIColor.rgb(red: 51 , green: 48 , blue: 53, alpha: 1)
        
        //UI
        static let NOIR_LOGIN_BACKGROUND = NOIR_RED_DARK
        static let NOIR_LOGIN_TINT = NOIR_YELLOW
        static let NOIR_STATUS_BAR = NOIR_RED_LIGHT
        static let NOIR_NAV_BAR = NOIR_RED_MEDIUM
        static let NOIR_TINT = NOIR_YELLOW
        static let NOIR_MENU_TINT = NOIR_RED_DARK
        static let NOIR_HIGHLIGHT = NOIR_YELLOW
        static let NOIR_BACKGROUND = NOIR_RED_DARK
        static let NOIR_BUTTON = NOIR_YELLOW
        static let NOIR_LOGO_TINT = NOIR_YELLOW
        static let NOIR_MEMBER_BORDER_ONLINE = NOIR_CG_YELLOW
        static let NOIR_MEMBER_BORDER_OFFLINE = NOIR_CG_ORANGE
        static let NOIR_CHAT_BUBBLE_SENT = NOIR_YELLOW
        static let NOIR_CHAT_BUBBLE_RECIEVED = NOIR_YELLOW
        static let NOIR_RECENT_MESSAGES_DIVIDER = NOIR_YELLOW
        
      
    }
    
    struct App {
        static let NOIR_LOGO = "noir_logo"
        static let NOIR_LOGO_BIG = "noir_big_logo"
        
    }
    
    struct Text {
        //copyright constant
        static let COPYRIGHT_LINE = "Copyright 2018, Savage Code, LLC"
        //Titles
        static let TITLE_LOGIN_ERROR = "Login Error"
        static let TITLE_USER_PROFILE_ERROR = "User Profile Error"
        static let TITLE_ERROR = "Noir Error"
        static let TITLE_RECOVER_PASSWORD = "Reset Account Password"
        //Error messages
        static let ERROR_WRONG_PASSWORD = "Incorrect Password"
        static let ERROR_UNKNOWN_USERNAME = "Unkown Username, please try again."
        static let ERROR_BLANK_PASSWORD = "Username or Password fields are blank. Please enter your username and password."
        static let ERROR_GENERIC_LOGIN_FAILED = "Oops! Something went wrong while logging in."
        static let ERROR_INVALID_CREDENTIALS_FORMAT = "No special characters in the username are allowed. Email addresses must also include an '@' and a '.'."
        static let ERROR_INVALID_CREDENTIALS_LENGTH = "Please enter no more than 30 characters for your username or password."
        static let ERROR_USER_PROFILE_LOAD_FAILED = "Unable to load user profile."
        static let ERROR_REGISTER_USER_FIELD_BLANK = "Please enter your email address, password and be sure your password match."
        static let ERROR_REGISTER_CREDENTIALS_LENGTH = "Enter up to 30 characters for your username or password and up to 80 characters for your email address."
        static let ERROR_GENERIC = "Something went wrong"
        //Dialogue Box Text
        static let DIALOGUE_RECOVER_PASSWORD = "Enter Your Account Email Address Below."
        
    }
    
    struct ProfileDefaults {
        //User signup default values
        static let PROFILE_QUESTION_DEFAULT = "Unanswered"
        static let PROFILE_GENDER_DEFAULT = "male"
        static let PROFILE_WITHIN_DISTANCE_DEFAULT = 10
        static let PROFILE_LOCAL_LIMIT_DEFAULT = 25
        static let PROFILE_GLOBAL_LIMIT_DEFAULT = 50
        static let PROFILE_FLIRT_LIMIT_DEFAULT = 25
        static let PROFILE_FLIRT_COUNT = 0
        static let PROFILE_FAVORITE_LIMIT = 25
        static let PROFILE_FAVORITE_COUNT = 0
        static let PROFILE_MEMBERSHIP_DEFAULT = "basic"
        static let PROFILE_AD_FREE_DEFAULT = false
        static let PROFILE_ONLINE_DEFAULT = false
        static let PROFILE_APP_DEFAULT = "noir"
        static let PROFILE_FAVORITES_DEFAULT = ["5eINpheoSH"]
        static let PROFILE_FLIRT_DEFAULT = ["5eINpheoSH"]
        static let PROFILE_BLOCKED_DEFAULT = ["abcdefg"]
        static let PROFILE_ECHO_DEFAULT = false
    }
    
}
