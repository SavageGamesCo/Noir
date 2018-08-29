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
import CoreLocation
import Spring
import Onboard

class APIService: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        return cell
    }
    
    //Variables
    
//    var members = [Member()]
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
    
    lazy var navigationController: UINavigationController = {
        
        let cv = UINavigationController()
        cv.delegate = self
        return cv
    }()
    
    //API Service Functions
    
    //Tutorial
    fileprivate func setupNewTutorialPage(_ newPage: OnboardingContentViewController, topPad: CGFloat, underIconPad: CGFloat, underTitlePad: CGFloat, bottomPad: CGFloat) {
        newPage.movesToNextViewController = true
        newPage.iconImageView.contentMode = .scaleAspectFit
        newPage.iconImageView.clipsToBounds = true
        newPage.topPadding = topPad;
        newPage.underIconPadding = underIconPad;
        newPage.underTitlePadding = underTitlePad;
        newPage.bottomPadding = bottomPad;
        newPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        newPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        newPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        newPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
    }
    
    func generateOnboarding() -> OnboardingViewController {
        let introPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_INTRO_TITLE, body: Constants.Text.TUTORIAL_INTRO_BODY, image: UIImage(named:"noir_logo_white"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let navigationPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_NAVIGATION_TITLE, body: Constants.Text.TUTORIAL_NAVIGATION_BODY, image: UIImage(named:"tutorial_navigation"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let membersPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_MEMBER_TITLE, body: Constants.Text.TUTORIAL_MEMBER_BODY, image: UIImage(named:"tutorial_global_local"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        
        let memberProfilePage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_MEMBER_PROFILE_TITLE, body: Constants.Text.TUTORIAL_MEMBER_PROFILE_BODY, image: UIImage(named:"tutorial_members_profile"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let flirtsPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_FLIRTS_TITLE, body: Constants.Text.TUTORIAL_FLIRTS_BODY, image: UIImage(named:"noir_heart"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let chatPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_CHAT_TITLE, body: Constants.Text.TUTORIAL_CHAT_BODY, image: UIImage(named:"chat_tutorial_image"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let settingsPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_SETTINGS_TITLE, body: Constants.Text.TUTORIAL_SETTINGS_BODY, image: UIImage(named:"settings_tutorial_image"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let echoPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_ECHO_TITLE, body: Constants.Text.TUTORIAL_ECHO_BODY, image: UIImage(named:"echo_tutorial_image"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let shopPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_SHOP_TITLE, body: Constants.Text.TUTORIAL_SHOP_BODY, image: UIImage(named:"shop_tutorial_image"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let loginViewController = LoginController()
        
        let outroPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_OUTRO_TITLE, body: Constants.Text.TUTORIAL_OUTRO_BODY, image: nil, buttonText: "Enjoy!") { () -> Void in
            
//            self.navigationController.pushViewController(loginViewController, animated: true)
            self.navigationController.popToViewController(loginViewController, animated: true)
        }
        
        
        
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "splash_jpeg"), contents: [introPage, navigationPage, membersPage, memberProfilePage, flirtsPage, chatPage, settingsPage, echoPage, shopPage, outroPage])
        onboardingVC?.shouldFadeTransitions = true
        onboardingVC?.swipingEnabled = true
        onboardingVC?.allowSkipping = true
        onboardingVC?.fadeSkipButtonOnLastPage = true
        onboardingVC?.skipHandler = {
            
            let window = UIWindow()
            
            window.rootViewController = UINavigationController(rootViewController: loginViewController)
            
            window.makeKeyAndVisible()
            
//            self.navigationController.pushViewController(loginViewController, animated: true)

//            self.navigationController.popToViewController(loginViewController, animated: true)
        }
        
        setupNewTutorialPage(introPage, topPad: 50, underIconPad: 20, underTitlePad: 15, bottomPad: 20)
        setupNewTutorialPage(navigationPage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        setupNewTutorialPage(membersPage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        setupNewTutorialPage(memberProfilePage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        setupNewTutorialPage(flirtsPage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        setupNewTutorialPage(chatPage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        setupNewTutorialPage(settingsPage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        setupNewTutorialPage(echoPage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        setupNewTutorialPage(shopPage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        setupNewTutorialPage(outroPage, topPad: 20, underIconPad: 10, underTitlePad: 10, bottomPad: 20)
        
        return onboardingVC!
    }
    
    //Parse Database Functions
    func fetchGlobalMembers( completion: @escaping ([Member]) -> () ) {
        
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
                    let member = Member()
                    if let user = object as? PFUser {
                        
                        if let blockedUsers = PFUser.current()?["blocked"] {
                            if (blockedUsers as AnyObject).contains(user.objectId! as String!){
                                //do nothing if the user id is in the current user's blocked list
                            } else {
                                
                                
                                let imageFile = user["mainPhoto"] as! PFFile
                                
                                imageFile.getDataInBackground(block: {(data, error) in
                                    
                                    if user["echo"] as! Bool {
                                        member.echo = true
                                    } else {
                                        member.echo = false
                                    }
                                    
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
                                    
                                    if let statusText = user["hivStatus"] as? String {
                                        member.status = statusText
                                    } else {
                                        member.status = "Unanswered"
                                    }
                                    
                                    if user["location"] != nil {
                                        let mlat = (user["location"] as AnyObject).latitude
                                        member.mLat = mlat
                                    } else {
                                        member.mLat = 0
                                    }
                                    
                                    if user["location"] != nil {
                                        let mlong = (user["location"] as AnyObject).longitude
                                        member.mLong = mlong
                                    } else {
                                        member.mLong = 0
                                    }
                                    
                                    member.memberOnline = true
                                    
                                    let imageData = data
                                    member.memberImage = (UIImage(data: imageData!)!)
                                    
                                })
                              members.append(member)
                            }
                           
                        }
                        
                    }
                    //end of for loop
                    
                }
                completion(members)
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
                            let member = Member()
                            
                            if let user = object as? PFUser {
                                
                                if let blockedUsers = PFUser.current()?["blocked"] {
                                    if ( blockedUsers as AnyObject).contains(user.objectId! as String!){
                                        
                                    } else {
                                        
                                        let imageFile = user["mainPhoto"] as! PFFile
                                        
                                        imageFile.getDataInBackground(block: {(data, error) in
                                            member.memberOnline = true
                                            
                                            if user["echo"] != nil && user["echo"] as! Bool {
                                                member.echo = true
                                            } else {
                                                member.echo = false
                                            }
                                            
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
                                            
                                            if let statusText = user["hivStatus"] as? String {
                                                member.status = statusText
                                            } else {
                                                member.status = "Unanswered"
                                            }
                                            
                                            if user["location"] != nil {
                                                let mlat = (user["location"] as AnyObject).latitude
                                                member.mLat = mlat
                                            } else {
                                                member.mLat = 0
                                            }
                                            
                                            if user["location"] != nil {
                                                let mlong = (user["location"] as AnyObject).longitude
                                                member.mLong = mlong
                                            } else {
                                                member.mLong = 0
                                            }
                                            
                                            let imageData = data
                                            member.memberImage = (UIImage(data: imageData!)!)
                                            
                                        })
                                        members.append(member)
                                    }
                                    
                                }
                                
                            }
                            //end of for loop
                            
                        }
                        completion(members)
                    }
                    
                })
            }
        }
    }
    
    func fetchFavorites( completion: @escaping ([Member]) -> () ) {
        
        let favorites = PFUser.current()?["favorites"] as? NSArray
        
        var fMembers = [Member]()
        
        for object in favorites! {
            
            let id = object as! String
            
            let Oquery = PFUser.query()
            Oquery?.order(byDescending: "updatedAt")
            Oquery?.getObjectInBackground(withId: id, block: { (fObject, error) in
                if let fMember = fObject as? PFUser {
                    let member = Member()
                    
                    let imageFile = fMember["mainPhoto"] as! PFFile
                    
                    imageFile.getDataInBackground(block: {(data, error) in
                        
                        let imageData = data
                        member.memberImage = (UIImage(data: imageData!)!)
                        member.memberName = fMember.username
                        
                        if let memberIDText = fMember.objectId {
                            member.memberID = memberIDText
                        } else {
                            return
                        }
                        
                        if let memberNameText = fMember.username {
                            member.memberName = memberNameText
                        } else {
                            return
                        }
                        
                        if let aboutText = fMember["about"] as? String {
                            member.about = aboutText
                        } else {
                            member.about = "Unanswered"
                        }
                        
                        if let ageText = fMember["age"] as? String {
                            member.age = ageText
                        } else {
                            member.age = "Unanswered"
                        }
                        
                        if let genderText = fMember["gender"] as? String {
                            member.gender = genderText
                        } else {
                            member.gender = "Unanswered"
                        }
                        
                        if let bodyText = fMember["body"] as? String {
                            member.body = bodyText
                        } else {
                            member.body = "Unanswered"
                        }
                        
                        if let heightText = fMember["height"] as? String {
                            member.height = heightText
                        } else {
                            member.height = "Unanswered"
                        }
                        
                        if let weightText = fMember["weight"] as? String {
                            member.weight = weightText
                        } else {
                            member.weight = "Unanswered"
                        }
                        
                        if let maritalStatusText = fMember["marital"] as? String {
                            member.maritalStatus = maritalStatusText
                        } else {
                            member.maritalStatus = "Unanswered"
                        }
                        
                        if let raceText = fMember["ethnicity"] as? String {
                            member.race = raceText
                        } else {
                            member.race = "Unanswered"
                        }
                        if fMember["location"] != nil {
                            let mlat = (fMember["location"] as AnyObject).latitude
                            member.mLat = mlat
                        } else {
                            member.mLat = 0
                        }
                        
                        if let statusText = fMember["hivStatus"] as? String {
                            member.status = statusText
                        } else {
                            member.status = "Unanswered"
                        }
                        
                        if fMember["location"] != nil {
                            let mlong = (fMember["location"] as AnyObject).longitude
                            member.mLong = mlong
                        } else {
                            member.mLong = 0
                        }
                        
                        if fMember["online"] as! Bool {
                            member.memberOnline = true
                        } else {
                            member.memberOnline = false
                        }
                        if fMember["echo"] != nil && fMember["echo"] as! Bool {
                            member.echo = true
                        } else {
                            member.echo = false
                        }
                     
                    })
                    fMembers.append(member)
                    
                }
                completion(fMembers)
            })
            
        }
       
        
    }
    
    func fetchFlirts( completion: @escaping ([Member]) -> () ) {
        
        let flirts = PFUser.current()?["flirt"] as? NSArray
        let blocked = PFUser.current()?["blocked"] as? NSArray
    
        var fMembers = [Member]()
        
        for object in flirts! {
            
            let id = object as! String
            
            if (blocked?.contains(id))!{
                
            } else {
                let Oquery = PFUser.query()
                Oquery?.getObjectInBackground(withId: id, block: { (fObject, error) in
                    if let fMember = fObject as? PFUser {
                        
                        let member = Member()
                        let imageFile = fMember["mainPhoto"] as! PFFile
                        
                        imageFile.getDataInBackground(block: {(data, error) in
                            
                            let imageData = data
                            member.memberImage = (UIImage(data: imageData!)!)
                            member.memberName = fMember.username
                            
                            if let memberIDText = fMember.objectId {
                                member.memberID = memberIDText
                            } else {
                                return
                            }
                            
                            if let memberNameText = fMember.username {
                                member.memberName = memberNameText
                            } else {
                                return
                            }
                            
                            if let aboutText = fMember["about"] as? String {
                                member.about = aboutText
                            } else {
                                member.about = "Unanswered"
                            }
                            
                            if let ageText = fMember["age"] as? String {
                                member.age = ageText
                            } else {
                                member.age = "Unanswered"
                            }
                            
                            if let genderText = fMember["gender"] as? String {
                                member.gender = genderText
                            } else {
                                member.gender = "Unanswered"
                            }
                            
                            if let bodyText = fMember["body"] as? String {
                                member.body = bodyText
                            } else {
                                member.body = "Unanswered"
                            }
                            
                            if let heightText = fMember["height"] as? String {
                                member.height = heightText
                            } else {
                                member.height = "Unanswered"
                            }
                            
                            if let weightText = fMember["weight"] as? String {
                                member.weight = weightText
                            } else {
                                member.weight = "Unanswered"
                            }
                            
                            if let maritalStatusText = fMember["marital"] as? String {
                                member.maritalStatus = maritalStatusText
                            } else {
                                member.maritalStatus = "Unanswered"
                            }
                            
                            if let raceText = fMember["ethnicity"] as? String {
                                member.race = raceText
                            } else {
                                member.race = "Unanswered"
                            }
                            
                            if let statusText = fMember["hivStatus"] as? String {
                                member.status = statusText
                            } else {
                                member.status = "Unanswered"
                            }
                            
                            if fMember["location"] != nil {
                                let mlat = (fMember["location"] as AnyObject).latitude
                                member.mLat = mlat
                            } else {
                                member.mLat = 0
                            }
                            
                            if fMember["location"] != nil {
                                let mlong = (fMember["location"] as AnyObject).longitude
                                member.mLong = mlong
                            } else {
                                member.mLong = 0
                            }
                            
                            if fMember["online"] as! Bool {
                                member.memberOnline = true
                            } else {
                                member.memberOnline = false
                            }
                            if fMember["echo"] != nil && fMember["echo"] as! Bool {
                                member.echo = true
                            } else {
                                member.echo = false
                            }
                           
                        })
                        fMembers.append(member)
                        

                    }
                    fMembers.reverse()
                    completion(fMembers)
                })
            }
            
        }
    }

    
    func fetchUserDetail() {
        
    }
    
    func fetchProfile() {
        
    }
    
    func flirt(member: Member) {

        if let flirt = PFUser.current()?["flirt"] as? NSArray {
            
//            let flirtlimit = PFUser.current()?["flirtLimit"] as! Int
            
            var tracking = ""
            
            if (flirt.count)  < 100 {
                tracking = "flirt"
                
                PFUser.current()?.addUniqueObjects(from: [member.memberID as String?], forKey: tracking)
                
                PFUser.current()?.saveInBackground(block: {(success, error) in
                    
                    if error != nil {
                        print(error!)
                    } else {
                        self.sendFlirtPush(member: member)
                        print("Flirt with " + (member.memberID)! + "added")
                    }
                    
                })
                
            } else {
               print("flirt limit reached")
//                self.dialogueBox(title: "Flirt Limit Reached", messageText: "You have reached your flirt limit. Visit the in-app store to learn how to get unlimited flirts, local members and global members.")
            }
            
        }
    }
    var favorite = Bool()
    
    func favorite(member: Member) {
        
        if let favoritesArray = PFUser.current()?["favorites"] as? NSArray {
            
//            let favoritesLimit = PFUser.current()?["favoritesLimit"] as! Int
            
            var tracking = ""
            
            if (favoritesArray.count)  < 50 {
                tracking = "favorites"
                if favoritesArray.contains(member.memberID as Any){
                    
                    PFUser.current()?.removeObjects(in: [member.memberID as String!], forKey: "favorites")
                    PFUser.current()?.saveInBackground(block: {(success, error) in
                        
                        if error != nil {
                            print("Error saving after favoriting user")
                        } else {
                            
                        }
                    })
                    
                } else {
                    PFUser.current()?.addUniqueObjects(from: [member.memberID as String!], forKey: tracking)
                    
                    PFUser.current()?.saveInBackground(block: {(success, error) in
                        
                        if error != nil {
                            print(error!)
                        } else {
                            
                            print("You favorited " + (member.memberID)! + "!")
                        }
                        
                    })
                }
                
                
            } else {
                print("favorites limit reached")
                //                self.dialogueBox(title: "Flirt Limit Reached", messageText: "You have reached your flirt limit. Visit the in-app store to learn how to get unlimited flirts, local members and global members.")
            }
            
        }
    }
    
    func blockUser(member: Member, view: UICollectionView) {
        PFUser.current()?.addUniqueObjects(from: [member.memberID as String!], forKey: "blocked")
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            if error != nil {
                print("Error saving after blocking user")
            } else {
                
                
            }
            
        })
    }
    
    func blockUserChat(member: Member, view: UIView) {
        PFUser.current()?.addUniqueObjects(from: [member.memberID as String!], forKey: "blocked")
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            if error != nil {
                print("Error saving after blocking user")
            } else {
                
                
            }
            
        })
    }
    func sendMessage(senderID: String, senderName: String, toUser: String, toUserName: String, text: String) {
        
        let chat = PFObject(className: "Chat")
        
        chat["senderID"] = senderID
        chat["senderName"] = senderName
        chat["text"] = text
        chat["url"] = ""
        chat["toUser"] = toUser
        chat["toUserName"] = toUserName
        chat["messageRead"] = false
        chat["chatID"] = toUser + senderID
        chat["app"] = APPLICATION
        
        chat.saveInBackground { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                
            }
            
        }
        
    }
    
    func sendFlirtPush(member: Member){
        sendMessage(senderID: (PFUser.current()?.objectId)!, senderName: (PFUser.current()?.username)!, toUser: member.memberID!, toUserName: member.memberName!, text: "\((PFUser.current()?.username)!) has sent you a flirt.")
        var installationID = PFInstallation()
        do {
            let user = try PFQuery.getUserObject(withId: member.memberID as String!)
            if user["installation"] != nil {
                installationID = (user["installation"] as? PFInstallation)!
            }
        }catch{
            print("No User Selected")
        }
        
        PFCloud.callFunction(inBackground: "sendPushToUserTest", withParameters: ["recipientId": member.memberID as String!, "chatmessage": "\(PFUser.current()!.username!) has sent you a flirt", "installationID": installationID.objectId as Any], block: { (object: Any?, error: Error?) in
            
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
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: ShopsharedSecret) { result in
            
            if case .success(let receipt) = result {
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    type: .autoRenewable,
                    productId: self.bundleID + ShopRegisteredPurchase.OneMonth.rawValue,
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
    
    func dialogueBox(title:String, messageText:String){
        let dialog = UIAlertController(title: title,
                                       message: messageText,
                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialog.addAction(defaultAction)
        // Present the dialog.
        
        
        mainView.present(dialog,animated: true)
        
    }
}
