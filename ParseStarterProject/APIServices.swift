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
    
    
    //API Service Functions
    
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
                                    member.memberName = user.username
                                    
                                    member.memberID = user.objectId
                                    
                                    if user["online"] as! Bool {
                                        member.memberOnline = true
                                    } else {
                                        member.memberOnline = false
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
                                            
                                            member.memberID = user.objectId
                                            
                                            if user["online"] as! Bool {
                                                member.memberOnline = true
                                            } else {
                                                member.memberOnline = false
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
                                    
                                    member.memberID = user.objectId
                                    
                                    if user["online"] as! Bool {
                                        member.memberOnline = true
                                    } else {
                                        member.memberOnline = false
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
    
    func fetchFlirts( completion: @escaping ([Member]) -> () ) {
        let query = PFUser.query()
        //Show Favorites
        query?.whereKey("app", equalTo: "noir")
//        query?.order(byDescending: "updatedAt")
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
                                    
                                    member.memberID = user.objectId
                                    
                                    if user["online"] as! Bool {
                                        member.memberOnline = true
                                    } else {
                                        member.memberOnline = false
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
}
