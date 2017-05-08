//
//  Member.swift
//  Noir
//
//  Created by Lynx on 5/8/17.
//  Copyright © 2017 Savage Code. All rights reserved.
//

import Foundation

class Member {
    private var _username = ""
    private var _userId = ""
    
    private var _profilePic = ""
    
    private var _age = ""
    private var _height = ""
    private var _weight = ""
    private var _ethnicity = ""
    private var _marital = ""
    private var _location = ""
    private var _about = ""
    
    init(id: String, name: String, pic: String, age: String, height: String, weight: String, ethnicity: String, marital: String, location: String, about: String){
        _userId = id
        _username = name
        _profilePic = pic
        _age = age
        _height = height
        _weight = weight
        _ethnicity = ethnicity
        _marital = marital
        _location = location
        _about = about
    }
    
    var username: String {
        return _username
    }
    
    var userID: String {
        return _userId
    }
    
    var profilePic: String {
        return _profilePic
    }
    
    var age: String {
        return _age
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var ethnicity: String {
        return _ethnicity
    }
    
    var marital: String {
        return _marital
    }
    
    var location: String {
        return _location
    }
    
    var about: String {
        return _about
    }
    
    
}
