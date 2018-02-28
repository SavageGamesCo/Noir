//
//  APIServices.swift
//  Noir
//
//  Created by Lynx on 2/13/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import Firebase
import GoogleMobileAds
import StoreKit
import SwiftyStoreKit
import AVFoundation
import MapKit
import Spring

class APIService: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        return cell
    }
    
    //Variables
    
    var members = [Member()]
    var blocked = [String]()
   
    var interstitial: GADInterstitial!
    //Constants
    let bundleID = "comsavagecodeNoir"
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    let refreshControl = UIRefreshControl()
    //Static constants
    static let sharedInstance = APIService()
    //Private vars
    private var subscription: Subscription<PFObject>!
    
    lazy var memberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Constants.Colors.NOIR_GREY_LIGHT
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var mainView: MainViewController = {
        
        let cv = MainViewController()
        
        return cv
    }()
    
    //API Service Functions
    
    //Parse Database Functions
    func fetchGlobalMembers( completion: @escaping ([Member]) -> () ) {
        var currentLocation = String()
        
        let query = PFUser.query()
        
        query?.addDescendingOrder("updatedAt")
        
        if PFUser.current()?["membership"] as! String != "basic" {
            
            query?.limit = 300
            
        } else {
            
            query?.limit = 150
            
        }
        query?.whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir")
        
        //Show All Users
        query?.findObjectsInBackground(block: {(objects, error) in
            
            if error != nil {
                print(error!)
            } else if let users = objects {
                
                var members = [Member]()
                
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if let blockedUsers = PFUser.current()?["blocked"] {
                            if (blockedUsers as AnyObject).contains(user.objectId! as String!){
                                //do nothing if the user id is in the current user's blocked list
                            } else {
                                let member = Member()
                                
                                let imageFile = user["mainPhoto"] as! PFFile
                                
                                imageFile.getDataInBackground(block: {(data, error) in
                                    
                                    let imageData = data
                                    member.memberImage = (UIImage(data: imageData!)!)
                                    
                                    if let memberIDText = user.objectId {
                                        member.memberID = memberIDText
                                    } else {
                                        return
                                    }
                                    
                                    if let memberNameText = user.username {
                                        member.memberName = memberNameText
                                    } else {
                                        return
                                    }
                                    
                                    if let aboutText = user["about"] as? String {
                                        member.about = aboutText
                                    } else {
                                        member.about = "Unanswered"
                                    }
                                    
                                    if let ageText = user["age"] as? String {
                                        member.age = ageText
                                    } else {
                                        member.age = "Unanswered"
                                    }
                                    
                                    if let genderText = user["gender"] as? String {
                                        member.gender = genderText
                                    } else {
                                        member.gender = "Unanswered"
                                    }
                                    
                                    if let bodyText = user["body"] as? String {
                                        member.body = bodyText
                                    } else {
                                        member.body = "Unanswered"
                                    }
                                    
                                    if let heightText = user["height"] as? String {
                                        member.height = heightText
                                    } else {
                                        member.height = "Unanswered"
                                    }
                                    
                                    if let weightText = user["weight"] as? String {
                                        member.weight = weightText
                                    } else {
                                        member.weight = "Unanswered"
                                    }
                                    
                                    if let maritalStatusText = user["marital"] as? String {
                                        member.maritalStatus = maritalStatusText
                                    } else {
                                        member.maritalStatus = "Unanswered"
                                    }
                                    
                                    if let raceText = user["ethnicity"] as? String {
                                        member.race = raceText
                                    } else {
                                        member.race = "Unanswered"
                                    }
                                    //Grab Location
                                    if let latitude = (user["location"] as AnyObject).latitude {
                                        if let longitude = (user["location"] as AnyObject).longitude {
                                            
                                            //get location & set location name
                                            let geoCoder = CLGeocoder()
                                            let location = CLLocation(latitude: latitude, longitude: longitude)
                                            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                                                
                                                // Place details
                                                var placeMark: CLPlacemark!
                                                placeMark = placemarks?[0]
                                                
                                                // Address dictionary
                                                //print(placeMark.addressDictionary as Any)
                                                var city = ""
                                                var state = ""
                                                var country = ""
                                                // City
                                                if placeMark != nil {
                                                    if placeMark.addressDictionary!["City"] != nil {
                                                        city = placeMark.addressDictionary!["City"] as! String
//                                                    print(city)
                                                    }
                                                    
                                                    // Country
                                                    if placeMark.addressDictionary!["State"] != nil {
                                                        state = placeMark.addressDictionary!["State"] as! String
//                                                   print(state)
                                                    }
                                                    
                                                    if placeMark.addressDictionary!["Country"] != nil {
                                                        country = placeMark.addressDictionary!["Country"] as! String
//                                                    print(country)
                                                    }
                                                    
                                                    currentLocation = (city) + ", " + (state)  + " " + (country)
                                                            
//                                                    print(currentLocation)
                                                    
                                                    member.location = currentLocation as String
                            
                                                }
                                                
                                            })
                                            
                                        }
                                    } else {
                                        member.location = "Unable to Retrieve Location"
                                    }
                                    //End of grabbing and setting location
                                    
                                    if user["online"] as! Bool {
                                        member.memberOnline = true
                                    } else {
                                        member.memberOnline = false
                                    }
                                    
                                    if user["echo"] as! Bool {
                                        member.echo = true
                                    } else {
                                        member.echo = false
                                    }
                                    
                                })
                                members.append(member)
                                
                                completion(members)
                                DispatchQueue.main.async {
                                    self.memberCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    
    func fetchLocalMembers( completion: @escaping ([Member]) -> () ) {
        
        let query = PFUser.query()
        //Show Local Users
        query?.addDescendingOrder("updatedAt")
        
        if PFUser.current()?["membership"] as! String != "basic" {
            
            query?.limit = 300
            
        } else {
            
            query?.limit = 25
            
        }
        
        
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                
                var withinDistance = Int()
                
                if PFUser.current()?["membership"] as? String == "basic" {
                    query?.limit = PFUser.current()?["localLimit"] as! Int
                    withinDistance = (PFUser.current()?["withinDistance"] as? Int)!
                } else {
                    withinDistance = (PFUser.current()?["withinDistance"] as? Int)!
                }
                
                query?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: Double(withinDistance)).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                
                query?.order(byDescending: "location")
                
                query?.findObjectsInBackground(block: {(objects, error) in
                    
                    if error != nil {
                        print(error!)
                    } else if let users = objects {
                        
                        var members = [Member]()
                        
                        for object in users {
                            if let user = object as? PFUser {
                                
                                if let blockedUsers = PFUser.current()?["blocked"] {
                                    if ( blockedUsers as AnyObject).contains(user.objectId! as String!){
                                        
                                    } else {
                                        let member = Member()
                                        
                                        let imageFile = user["mainPhoto"] as! PFFile
                                        
                                        imageFile.getDataInBackground(block: {(data, error) in
                                            
                                            let imageData = data
                                            member.memberImage = (UIImage(data: imageData!)!)
                                            member.memberName = user.username
                                            
                                            if let memberIDText = user.objectId {
                                                member.memberID = memberIDText
                                            } else {
                                                return
                                            }
                                            
                                            if let memberNameText = user.username {
                                                member.memberName = memberNameText
                                            } else {
                                                return
                                            }
                                            
                                            if let aboutText = user["about"] as? String {
                                                member.about = aboutText
                                            } else {
                                                member.about = "Unanswered"
                                            }
                                            
                                            if let ageText = user["age"] as? String {
                                                member.age = ageText
                                            } else {
                                                member.age = "Unanswered"
                                            }
                                            
                                            if let genderText = user["gender"] as? String {
                                                member.gender = genderText
                                            } else {
                                                member.gender = "Unanswered"
                                            }
                                            
                                            if let bodyText = user["body"] as? String {
                                                member.body = bodyText
                                            } else {
                                                member.body = "Unanswered"
                                            }
                                            
                                            if let heightText = user["height"] as? String {
                                                member.height = heightText
                                            } else {
                                                member.height = "Unanswered"
                                            }
                                            
                                            if let weightText = user["weight"] as? String {
                                                member.weight = weightText
                                            } else {
                                                member.weight = "Unanswered"
                                            }
                                            
                                            if let maritalStatusText = user["marital"] as? String {
                                                member.maritalStatus = maritalStatusText
                                            } else {
                                                member.maritalStatus = "Unanswered"
                                            }
                                            
                                            if let raceText = user["ethnicity"] as? String {
                                                member.race = raceText
                                            } else {
                                                member.race = "Unanswered"
                                            }
                                            //Grab Location
                                            if let latitude = (user["location"] as AnyObject).latitude {
                                                if let longitude = (user["location"] as AnyObject).longitude {
                                                    
                                                    //get location & set location name
                                                    let geoCoder = CLGeocoder()
                                                    let location = CLLocation(latitude: latitude, longitude: longitude)
                                                    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                                                        
                                                        // Place details
                                                        var placeMark: CLPlacemark!
                                                        placeMark = placemarks?[0]
                                                        
                                                        // Address dictionary
                                                        //print(placeMark.addressDictionary as Any)
                                                        var city = ""
                                                        var state = ""
                                                        var country = ""
                                                        // City
                                                        if placeMark != nil {
                                                            if placeMark.addressDictionary!["City"] != nil {
                                                                city = placeMark.addressDictionary!["City"] as! String
                                                                //                                                    print(city)
                                                            }
                                                            
                                                            // Country
                                                            if placeMark.addressDictionary!["State"] != nil {
                                                                state = placeMark.addressDictionary!["State"] as! String
                                                                //                                                   print(state)
                                                            }
                                                            
                                                            if placeMark.addressDictionary!["Country"] != nil {
                                                                country = placeMark.addressDictionary!["Country"] as! String
                                                                //                                                    print(country)
                                                            }
                                                            
                                                            currentLocation = (city) + ", " + (state)  + " " + (country) as NSString
                                                            
                                                            //                                                    print(currentLocation)
                                                            
                                                            member.location = currentLocation as String
                                                            
                                                        }
                                                        
                                                    })
                                                    
                                                }
                                            } else {
                                                member.location = "Unable to Retrieve Location"
                                            }
                                            //End of grabbing and setting location
                                            
                                            if user["online"] as! Bool {
                                                member.memberOnline = true
                                            } else {
                                                member.memberOnline = false
                                            }
                                            
                                            if user["echo"] != nil && user["echo"] as! Bool {
                                                member.echo = true
                                            } else {
                                                member.echo = false
                                            }
                                            
                                        })
                                        
                                        
                                        DispatchQueue.main.async {
                                            members.append(member)
                                            completion(members)
                                            self.memberCollectionView.reloadData()
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    
                })
            }
        }
    }
    
    func fetchFavorites( completion: @escaping ([Member]) -> () ) {
        let query = PFUser.query()
        //Show Favorites
        query?.whereKey("app", equalTo: "noir")
        query?.findObjectsInBackground(block: {(objects, error) in
            
            if error != nil {
                print(error!)
            } else if let users = objects {
                
                var members = [Member]()
                
                for object in users {
                    if let user = object as? PFUser {
                        
                        let member = Member()
                        
                        if let favoriteUsers = PFUser.current()?["favorites"] {
                            if (favoriteUsers as AnyObject).contains(user.objectId! as String!){
                                
                                let imageFile = user["mainPhoto"] as! PFFile
                                
                                imageFile.getDataInBackground(block: {(data, error) in
                                    
                                    let imageData = data
                                    member.memberImage = (UIImage(data: imageData!)!)
                                    member.memberName = user.username
                                    
                                    if let memberIDText = user.objectId {
                                        member.memberID = memberIDText
                                    } else {
                                        return
                                    }
                                    
                                    if let memberNameText = user.username {
                                        member.memberName = memberNameText
                                    } else {
                                        return
                                    }
                                    
                                    if let aboutText = user["about"] as? String {
                                        member.about = aboutText
                                    } else {
                                        member.about = "Unanswered"
                                    }
                                    
                                    if let ageText = user["age"] as? String {
                                        member.age = ageText
                                    } else {
                                        member.age = "Unanswered"
                                    }
                                    
                                    if let genderText = user["gender"] as? String {
                                        member.gender = genderText
                                    } else {
                                        member.gender = "Unanswered"
                                    }
                                    
                                    if let bodyText = user["body"] as? String {
                                        member.body = bodyText
                                    } else {
                                        member.body = "Unanswered"
                                    }
                                    
                                    if let heightText = user["height"] as? String {
                                        member.height = heightText
                                    } else {
                                        member.height = "Unanswered"
                                    }
                                    
                                    if let weightText = user["weight"] as? String {
                                        member.weight = weightText
                                    } else {
                                        member.weight = "Unanswered"
                                    }
                                    
                                    if let maritalStatusText = user["marital"] as? String {
                                        member.maritalStatus = maritalStatusText
                                    } else {
                                        member.maritalStatus = "Unanswered"
                                    }
                                    
                                    if let raceText = user["ethnicity"] as? String {
                                        member.race = raceText
                                    } else {
                                        member.race = "Unanswered"
                                    }
                                    //Grab Location
                                    if let latitude = (user["location"] as AnyObject).latitude {
                                        if let longitude = (user["location"] as AnyObject).longitude {
                                            
                                            //get location & set location name
                                            let geoCoder = CLGeocoder()
                                            let location = CLLocation(latitude: latitude, longitude: longitude)
                                            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                                                
                                                // Place details
                                                var placeMark: CLPlacemark!
                                                placeMark = placemarks?[0]
                                                
                                                // Address dictionary
                                                //print(placeMark.addressDictionary as Any)
                                                var city = ""
                                                var state = ""
                                                var country = ""
                                                // City
                                                if placeMark != nil {
                                                    if placeMark.addressDictionary!["City"] != nil {
                                                        city = placeMark.addressDictionary!["City"] as! String
                                                        //                                                    print(city)
                                                    }
                                                    
                                                    // Country
                                                    if placeMark.addressDictionary!["State"] != nil {
                                                        state = placeMark.addressDictionary!["State"] as! String
                                                        //                                                   print(state)
                                                    }
                                                    
                                                    if placeMark.addressDictionary!["Country"] != nil {
                                                        country = placeMark.addressDictionary!["Country"] as! String
                                                        //                                                    print(country)
                                                    }
                                                    
                                                    currentLocation = (city) + ", " + (state)  + " " + (country) as NSString
                                                    
                                                    //                                                    print(currentLocation)
                                                    
                                                    member.location = currentLocation as String
                                                    
                                                }
                                                
                                            })
                                            
                                        }
                                    } else {
                                        member.location = "Unable to Retrieve Location"
                                    }
                                    //End of grabbing and setting location
                                    
                                    if user["online"] as! Bool {
                                        member.memberOnline = true
                                    } else {
                                        member.memberOnline = false
                                    }
                                    if user["echo"] != nil && user["echo"] as! Bool {
                                        member.echo = true
                                    } else {
                                        member.echo = false
                                    }
                                    
                                })
                                
                                members.append(member)
                                completion(members)
                                DispatchQueue.main.async {
                                    
                                    self.memberCollectionView.reloadData()
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
        })
    }
    
    func fetchFlirts( completion: @escaping ([Member]) -> () ) {
        let query = PFUser.query()
        //Show Favorites
        query?.whereKey("app", equalTo: "noir")
        
        query?.findObjectsInBackground(block: {(objects, error) in
            
            if error != nil {
                print(error!)
            } else if let users = objects {
                
                var members = [Member]()
                
                for object in users {
                    if let user = object as? PFUser {
                        
                        let member = Member()
                        
                        if let favoriteUsers = PFUser.current()?["flirt"] {
                            if (favoriteUsers as AnyObject).contains(user.objectId! as String!){
                                
                                let imageFile = user["mainPhoto"] as! PFFile
                                
                                imageFile.getDataInBackground(block: {(data, error) in
                                    
                                    let imageData = data
                                    member.memberImage = (UIImage(data: imageData!)!)
                                    member.memberName = user.username
                                    
                                    if let memberIDText = user.objectId {
                                        member.memberID = memberIDText
                                    } else {
                                        return
                                    }
                                    
                                    if let memberNameText = user.username {
                                        member.memberName = memberNameText
                                    } else {
                                        return
                                    }
                                    
                                    if let aboutText = user["about"] as? String {
                                        member.about = aboutText
                                    } else {
                                        member.about = "Unanswered"
                                    }
                                    
                                    if let ageText = user["age"] as? String {
                                        member.age = ageText
                                    } else {
                                        member.age = "Unanswered"
                                    }
                                    
                                    if let genderText = user["gender"] as? String {
                                        member.gender = genderText
                                    } else {
                                        member.gender = "Unanswered"
                                    }
                                    
                                    if let bodyText = user["body"] as? String {
                                        member.body = bodyText
                                    } else {
                                        member.body = "Unanswered"
                                    }
                                    
                                    if let heightText = user["height"] as? String {
                                        member.height = heightText
                                    } else {
                                        member.height = "Unanswered"
                                    }
                                    
                                    if let weightText = user["weight"] as? String {
                                        member.weight = weightText
                                    } else {
                                        member.weight = "Unanswered"
                                    }
                                    
                                    if let maritalStatusText = user["marital"] as? String {
                                        member.maritalStatus = maritalStatusText
                                    } else {
                                        member.maritalStatus = "Unanswered"
                                    }
                                    
                                    if let raceText = user["ethnicity"] as? String {
                                        member.race = raceText
                                    } else {
                                        member.race = "Unanswered"
                                    }
                                    //Grab Location
                                    if let latitude = (user["location"] as AnyObject).latitude {
                                        if let longitude = (user["location"] as AnyObject).longitude {
                                            
                                            //get location & set location name
                                            let geoCoder = CLGeocoder()
                                            let location = CLLocation(latitude: latitude, longitude: longitude)
                                            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                                                
                                                // Place details
                                                var placeMark: CLPlacemark!
                                                placeMark = placemarks?[0]
                                                
                                                // Address dictionary
                                                //print(placeMark.addressDictionary as Any)
                                                var city = ""
                                                var state = ""
                                                var country = ""
                                                // City
                                                if placeMark != nil {
                                                    if placeMark.addressDictionary!["City"] != nil {
                                                        city = placeMark.addressDictionary!["City"] as! String
                                                        //                                                    print(city)
                                                    }
                                                    
                                                    // Country
                                                    if placeMark.addressDictionary!["State"] != nil {
                                                        state = placeMark.addressDictionary!["State"] as! String
                                                        //                                                   print(state)
                                                    }
                                                    
                                                    if placeMark.addressDictionary!["Country"] != nil {
                                                        country = placeMark.addressDictionary!["Country"] as! String
                                                        //                                                    print(country)
                                                    }
                                                    
                                                    currentLocation = (city) + ", " + (state)  + " " + (country) as NSString
                                                    
                                                    //                                                    print(currentLocation)
                                                    
                                                    member.location = currentLocation as String
                                                    
                                                }
                                                
                                            })
                                            
                                        }
                                    } else {
                                        member.location = "Unable to Retrieve Location"
                                    }
                                    //End of grabbing and setting location
                                    
                                    if user["online"] as! Bool {
                                        member.memberOnline = true
                                    } else {
                                        member.memberOnline = false
                                    }
                                    if user["echo"] != nil && user["echo"] as! Bool {
                                        member.echo = true
                                    } else {
                                        member.echo = false
                                    }
                                    
                                })
                                
                                
                                DispatchQueue.main.async {
                                    members.append(member)
                                    members.reverse()
                                    completion(members)
                                    self.memberCollectionView.reloadData()
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
        })
    }

    
    func fetchUserDetail() {
        
    }
    
    func fetchProfile() {
        
    }
    
    func flirt(member: Member) {

        if let flirt = PFUser.current()?["flirt"] as? NSArray {
            
            let flirtlimit = PFUser.current()?["flirtLimit"] as! Int
            
            var tracking = ""
            
            if (flirt.count)  < 50 {
                tracking = "flirt"
                
                let flirtGraphic = SpringImageView()
                
                flirtGraphic.image = UIImage(named: "flirt_2.png")
                flirtGraphic.contentMode = .scaleAspectFill
                //flirtGraphic.y = -50
                flirtGraphic.autostart = true
                flirtGraphic.animation = "zoomIn"
                flirtGraphic.animateToNext {
                    flirtGraphic.animation = "zoomOut"
                    flirtGraphic.animateTo()
                    
                }
                
                
                flirtGraphic.frame = CGRect(x: (memberCollectionView.center.x) / 4, y: (memberCollectionView.center.y) / 4, width: 300, height: 300)
                
                flirtGraphic.center = CGPoint(x: memberCollectionView.frame.size.width  / 2, y: memberCollectionView.frame.size.height / 2);
                
                memberCollectionView.addSubview(flirtGraphic)
                
                PFUser.current()?.addUniqueObjects(from: [member.memberID as String!], forKey: tracking)
                
                PFUser.current()?.saveInBackground(block: {(success, error) in
                    self.sendFlirtPush(member: member)
                    print("Flirt with " + (member.memberID)! + "added")
                })
                
            } else {
               print("flirt limit reached")
//                self.dialogueBox(title: "Flirt Limit Reached", messageText: "You have reached your flirt limit. Visit the in-app store to learn how to get unlimited flirts, local members and global members.")
            }
            
        }
    }
    var favorite = Bool()
    
    func favorite(member: Member) {
        
        
        if favorite == true {
            
            PFUser.current()?.removeObjects(in: [member.memberID as String!], forKey: "favorites")
            
            PFUser.current()?.saveInBackground(block: {(success, error) in
                
            })
            
            let query = PFUser.query()
            
            query?.whereKey("app", equalTo: APPLICATION)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error != nil {
                    
                } else if let users = objects {
                    for object in users {
                        if object is PFUser {
                            if let favorites = PFUser.current()?["favorites"] {
                                if (favorites as AnyObject).contains(member.memberID as String!) {
                                    self.favorite = true
                                } else {
                                    self.favorite = false
                                }
                            }
                        }
                    }
                }
            })
            
            favorite = false
            
        } else {
            
            let favoriteIcon = SpringImageView()
            
            favoriteIcon.image = UIImage(named: "favorite.png")
            favoriteIcon.contentMode = .scaleAspectFill
            //flirtGraphic.y = -50
            favoriteIcon.autostart = true
            favoriteIcon.animation = "zoomIn"
            favoriteIcon.animateToNext {
                favoriteIcon.animation = "zoomOut"
                favoriteIcon.animateTo()
                
            }
            
            
            favoriteIcon.frame = CGRect(x: memberCollectionView.frame.size.width / 2, y: memberCollectionView.frame.size.height  / 2 , width: 600, height: 362)
            
            favoriteIcon.center = CGPoint(x: memberCollectionView.frame.size.width  / 2, y: memberCollectionView.frame.size.height / 2);
            var window = UIWindow()
            window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.addSubview(favoriteIcon)
            
            PFUser.current()?.addUniqueObjects(from: [member.memberID as String!], forKey: "favorites")
            
            PFUser.current()?.saveInBackground(block: {(success, error) in
                
            })
            
            let query = PFUser.query()
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error != nil {
                    
                } else if let users = objects {
                    for object in users {
                        if object is PFUser {
                            if let favorites = PFUser.current()?["favorites"] {
                                if (favorites as AnyObject).contains(member.memberID as String!) {
                                    self.favorite = true
                                  
                                } else {
                                    self.favorite = false
                                    
                                }
                            }
                        }
                    }
                }
            })
            
            favorite = true
            
        }
    }
    
    func blockUser(member: Member, view: UICollectionView) {
        PFUser.current()?.addUniqueObjects(from: [member.memberID as String!], forKey: "blocked")
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            if error != nil {
                print("Error saving after blocking user")
            } else {
                
                view.reloadData()
            }
            
        })
    }
    
    func sendFlirtPush(member: Member){
        
        var installationID = PFInstallation()
        do {
            let user = try PFQuery.getUserObject(withId: member.memberID as String!)
            if user["installation"] != nil {
                installationID = (user["installation"] as? PFInstallation)!
            }
        }catch{
            print("No User Selected")
        }
        
        PFCloud.callFunction(inBackground: "sendPushToUserTest", withParameters: ["recipientId": member.memberID as String!, "chatmessage": "\(PFUser.current()!.username!) has flirted with you", "installationID": installationID.objectId as Any], block: { (object: Any?, error: Error?) in
            
            if error != nil {
                print(error!)
            } else {
                
                print("PFCloud push was successful")
            }
            
        })
        
    }
    
    
    //Apple Store Functions
    func validateAppleReciepts() {
        //validate subscription receipt
        let appleValidator = AppleReceiptValidator(service: .production)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: sharedSecret) { result in
            
            if case .success(let receipt) = result {
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    type: .autoRenewable,
                    productId: self.bundleID + RegisteredPurchase.OneMonth.rawValue,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .expired(let expiryDate):
                    print("Product is expired since \(expiryDate)")
                    PFUser.current()?["membership"] = "basic"
                    PFUser.current()?.saveInBackground()
                case .notPurchased:
                    print("This product has never been purchased")
                    PFUser.current()?["membership"] = "basic"
                    PFUser.current()?.saveInBackground()
                    
                default:
                    print("Membership is active and not expired")
                    
                    PFUser.current()?["membership"] = "oneMonth"
                    PFUser.current()?.saveInBackground()
                    
                    break
                }
                
            } else {
                // receipt verification error
            }
        }
        //end validate subscription
    }
    
    //Utilities
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func dialogueBoxFlirt(title:String, messageText:String, member: Member ){
        let dialog = UIAlertController(title: title,
                                       message: messageText,
                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialog.addAction(defaultAction)
        // Present the dialog.
        func sendFlirtPush(){
            
            var installationID = PFInstallation()
            do {
                let user = try PFQuery.getUserObject(withId: member.memberID as String!)
                if user["installation"] != nil {
                    installationID = (user["installation"] as? PFInstallation)!
                }
            }catch{
                print("No User Selected")
            }
            
            PFCloud.callFunction(inBackground: "sendPushToUserTest", withParameters: ["recipientId": member.memberID as String!, "chatmessage": "\(PFUser.current()!.username!) has flirted with you", "installationID": installationID.objectId as Any], block: { (object: Any?, error: Error?) in
                
                if error != nil {
                    print(error!)
                } else {
                    
                    print("PFCloud push was successful")
                }
                
            })
            
        }
        
        mainView.present(dialog,
                     animated: true,
                     completion: sendFlirtPush)
    }
}
