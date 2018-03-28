//
//  Constants.swift
//  Noir
//
//  Created by Lynx on 2/9/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

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
        
        static let NOIR_CG_GREEN = NOIR_GREEN.cgColor
        static let NOIR_CG_PURPLE_DARK = NOIR_PURPLE_DARK.cgColor
        static let NOIR_CG_ORANGE = NOIR_ORANGE.cgColor
        static let NOIR_CG_YELLOW = NOIR_YELLOW.cgColor
        
        static let NOIR_RED_DARK = UIColor.rgb(red: 58, green: 0, blue: 0, alpha: 1)
        static let NOIR_RED_LIGHT = UIColor.rgb(red: 156, green: 3, blue: 4, alpha: 1)
        static let NOIR_RED_MEDIUM = UIColor.rgb(red: 94, green: 4, blue: 9, alpha: 1)
        
        
        //Text Colors
        static let NOIR_LIGHT_TEXT = UIColor.init(white: 0.9, alpha: 1)
        static let NOIR_DARK_TEXT = UIColor.rgb(red: 51 , green: 48 , blue: 53, alpha: 1)
        static let NOIR_NAV_BAR_TEXT = NOIR_YELLOW
        static let NOIR_BUTTON_TEXT = NOIR_BLACK
        static let NOIR_MEMBER_TEXT = NOIR_YELLOW
        static let NOIR_CHAT_BUBBLE_SENT_TEXT = NOIR_YELLOW
        static let NOIR_CHAT_BUBBLE_RECIEVED_TEXT = NOIR_YELLOW
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
        static let NOIR_MEMBER_BORDER_OFFLINE = NOIR_CG_PURPLE_DARK
        static let NOIR_MEMBER_BORDER_ECHO = NOIR_CG_GREEN
        static let NOIR_CHAT_BUBBLE_SENT = NOIR_RED_MEDIUM
        static let NOIR_CHAT_BUBBLE_RECIEVED = NOIR_RED_LIGHT
        static let NOIR_RECENT_MESSAGES_DIVIDER = NOIR_YELLOW
        static let NOIR_RADIAL_MENU_BUTTON_TINT_COLOR = NOIR_RED_DARK
        static let NOIR_RADIAL_MENU_BUTTON_COLOR = NOIR_YELLOW
        
      
    }
    
    struct App {
        static let NOIR_LOGO = "noir_logo"
        static let NOIR_LOGO_BIG = "noir_big_logo"
        static let APPLICATION = "noir"
        static let CURRENT_USER = PFUser.current()?.objectId!
        static let CURRENT_USERNAME = PFUser.current()?.username!
        //Echo Helpers
        static let WithinArea = 11.0
        //FONT
        static let SYSTEM_FONT = UIFont.boldSystemFont(ofSize: 12)
        //SOUNDS
        static let SYSTEM_SOUND = 1016
        
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
        
        //Tutorial text
        static let TUTORIAL_INTRO_TITLE = "Welcome to Noir!"
        static let TUTORIAL_INTRO_BODY = "Thank you for trying Noir! Noir is a mobile dating app made for gay men of color and created by a gay man of color. View members worldwide or right around the corner. Fill your favorites list, flirt with other members, see who has flirted with you, chat, send pictures and more!"
        static let TUTORIAL_NAVIGATION_TITLE = "Navigating Noir"
        static let TUTORIAL_NAVIGATION_BODY = "There are two ways to navigate the Noir app. You can tap on an icon in the menu bar to instantly jump to a view or swipe left and right to peruse through. Swiping up or down will hide or show the Shopping/Settings Menu. In the Settings menu you can update your profile & add more profile images, view our terms or review this tutorial."
        static let TUTORIAL_MEMBER_TITLE = "Members, Members Everywhere!"
        static let TUTORIAL_MEMBER_BODY = "In Noir there are two modes to view members that are online. Global or Local. Global will list the most recently active members of Noir from around the world. Local will list the most recently active members in your area. Buying a monthly membership will increase how many members you see."
        static let TUTORIAL_MEMBER_PROFILE_TITLE = "Member Profiles"
        static let TUTORIAL_MEMBER_PROFILE_BODY = "Tap a member photo to expose a cricular menu. From this menu you can view the stats, their photos, send a flirt, add a favorite, chat or block the member. Use that last one wisely, once it is done, it cannot be undone."
        static let TUTORIAL_FLIRTS_TITLE = "Flirts and Favorites!"
        static let TUTORIAL_FLIRTS_BODY = "In the favorites view, you can view all of your favorite members and view their profiles whether they are online or not. The flirts view will show you members that have flirted with you. A flirt also initiates a chat session, making it easy to get in touch."
        static let TUTORIAL_CHAT_TITLE = "Chatting!"
        static let TUTORIAL_CHAT_BODY = "Chatting with a Noir Member is easy. Tap their member photo, tap chat and that's it. Want to check messages sent to you? The Messages menu item will take you there! Send photos to each other via chat, tapping on the photo will make it full screen!"
        static let TUTORIAL_SETTINGS_TITLE = "Updating Your Settings!"
        static let TUTORIAL_SETTINGS_BODY = "Noir supports one main photo shown in the Member views and four additional photos. Tap the photo to change it. Tapping the stats will allow you to change that stat. Tapping save will save your changes and new images to the server!"
        static let TUTORIAL_ECHO_TITLE = "Echo!"
        static let TUTORIAL_ECHO_BODY = "Echo has undergone some major changes but the use is still the same. Turn on Echo in your Profile Settings screen to let other members know that you are looking to connect right now! Members looking to connect with have an icon that has a color changing border and pulse on your screen to grab your attention."
        static let TUTORIAL_SHOP_TITLE = "Supporting Noir!"
        static let TUTORIAL_SHOP_BODY = "With your subscription you will see even more members in both Local and Global views, send unlimited flirts and save unlimited favorites! Noir is an effort from a tiny mobile software development house called Savage Code. Your monthly subscriptions or ad-free purchase goes directly to supporting this black owned development house and allows Savage Code to continue to update and maintain Noir."
        static let TUTORIAL_OUTRO_TITLE = "Enjoy Your Stay and Be Safe!"
        static let TUTORIAL_OUTRO_BODY = "Enjoy Noir but please be safe. Consider meeting in public, not divulging personal information immediately upon meeting and practice safer sex. PreP, Condoms and knowing your status most of all. Your personal safety and sexual health should be your number one priority. Have a blast!"
        
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
