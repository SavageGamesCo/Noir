//
//  EchoSonarViewController.swift
//  Noir
//
//  Created by Lynx on 6/29/17.
//  Copyright © 2017 Savage Code. All rights reserved.
//

import UIKit
import CoreLocation
import Sonar
import MapKit
import Parse
import ParseLiveQuery
import Firebase
import GoogleMobileAds
import UserNotifications

class EchoSonarViewController: UIViewController {

    @IBOutlet weak var sonarView: SonarView!
    fileprivate lazy var distanceFormatter: MKDistanceFormatter = MKDistanceFormatter()
    
    var memberIDLineFour = [String]()
    var memberNameLineFour = [String]()
    var memberPicLineFour = [UIImage]()
    
    var memberIDLineThree = [String]()
    var memberNameLineThree = [String]()
    var memberPicLineThree = [UIImage]()
    
    var memberIDLineTwo = [String]()
    var memberNameLineTwo = [String]()
    var memberPicLineTwo = [UIImage]()
    
    var memberIDLineOne = [String]()
    var memberNameLineOne = [String]()
    var memberPicLineOne = [UIImage]()
    
    var withinDistance = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SonarView.lineColor = ONLINE_COLOR
        SonarView.lineShadowColor = ONLINE_COLOR_2
        SonarView.distanceTextColor = ONLINE_COLOR
        
        sonarView.backgroundColor = UIColor.darkGray

        self.sonarView.delegate = self as? SonarViewDelegate
        self.sonarView.dataSource = self as? SonarViewDataSource
        
        if PFUser.current()?["echo"] as? Bool != true {
            
            sonarView.isHidden = true
            let label = UILabel()
            label.text = "Please Turn On Echo To Use This Feature."
            label.textColor = ONLINE_COLOR
            label.numberOfLines = 2
            label.center.x = self.view.center.x / 4
            label.center.y = self.view.center.y
            label.sizeToFit()
            label.textAlignment = .center
            
            self.view.addSubview(label)
        
        } else {
            
            update()
            var timer = Timer()
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            
            
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func geoPoint(){
        
        PFGeoPoint.geoPointForCurrentLocation(inBackground: {(geopoint, error) in
            
            print(geopoint!)
            if let geopoint = geopoint {
                PFUser.current()?["location"] = geopoint
                
                PFUser.current()?.saveInBackground()
            }
        })
        
        //Show Local Users
        
        
    }
    
    func update() {
        
        sonarView.reloadData()
        
        // Something cool
        let query = PFUser.query()
        let query2 = PFUser.query()
        let query3 = PFUser.query()
        let query4 = PFUser.query()
        //Show Local Users
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                
                
                
                //first
                query?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: Double(1) / 16).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                
                query?.findObjectsInBackground(block: {(objects, error) in
                    
                    if error != nil {
                        print(error!)
                    } else if let users = objects {
                        
                        self.memberNameLineOne.removeAll()
                        self.memberIDLineOne.removeAll()
                        self.memberPicLineOne.removeAll()
                        
                        
//                        self.sonarView.reloadData()
                        
                        for object in users {
                            if let user = object as? PFUser {
                                
                                if let blockedUsers = PFUser.current()?["blocked"] {
                                    if ( blockedUsers as AnyObject).contains(user.objectId! as String!){
                                        
                                    } else {
                                        let imageFile = user["mainPhoto"] as! PFFile
                                        
                                        imageFile.getDataInBackground(block: {(data, error) in
                                            
                                            if let imageData = data {
                                                self.memberPicLineOne.append(UIImage(data: imageData)!)
                                                
                                                self.memberNameLineOne.append(user.username!)
                                                self.memberIDLineOne.append(user.objectId!)
                                                
                                                //self.sonarView.reloadData()
                                            }
                                        })
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    
                    //second line
                    query2?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: Double(1) / 8).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                    
                    query2?.findObjectsInBackground(block: {(objects, error) in
                        
                        if error != nil {
                            print(error!)
                        } else if let users = objects {
                            
                            self.memberNameLineTwo.removeAll()
                            self.memberIDLineTwo.removeAll()
                            self.memberPicLineTwo.removeAll()
                            
                            
                            //                                self.sonarView.reloadData()
                            
                            for object in users {
                                if let user = object as? PFUser {
                                    
                                    if let blockedUsers = PFUser.current()?["blocked"] {
                                        if ( blockedUsers as AnyObject).contains(user.objectId! as String!) || self.memberIDLineOne.contains(user.objectId! as String!){
                                            
                                        } else {
                                            let imageFile = user["mainPhoto"] as! PFFile
                                            
                                            imageFile.getDataInBackground(block: {(data, error) in
                                                
                                                if let imageData = data {
                                                    self.memberPicLineTwo.append(UIImage(data: imageData)!)
                                                    
                                                    self.memberNameLineTwo.append(user.username!)
                                                    self.memberIDLineTwo.append(user.objectId!)
                                                    
                                                    //self.sonarView.reloadData()
                                                }
                                            })
                                            
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                        //third
                        query3?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: Double(1) / 4).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                        
                        query3?.findObjectsInBackground(block: {(objects, error) in
                            
                            if error != nil {
                                print(error!)
                            } else if let users = objects {
                                
                                self.memberNameLineThree.removeAll()
                                self.memberIDLineThree.removeAll()
                                self.memberPicLineThree.removeAll()
                                
                                
                                //                                    self.sonarView.reloadData()
                                
                                for object in users {
                                    if let user = object as? PFUser {
                                        
                                        if let blockedUsers = PFUser.current()?["blocked"] {
                                            if ( blockedUsers as AnyObject).contains(user.objectId! as String!) || self.memberIDLineOne.contains(user.objectId! as String!) || self.memberIDLineTwo.contains(user.objectId! as String!){
                                                
                                            } else {
                                                let imageFile = user["mainPhoto"] as! PFFile
                                                
                                                imageFile.getDataInBackground(block: {(data, error) in
                                                    
                                                    if let imageData = data {
                                                        self.memberPicLineThree.append(UIImage(data: imageData)!)
                                                        
                                                        self.memberNameLineThree.append(user.username!)
                                                        self.memberIDLineThree.append(user.objectId!)
                                                        
                                                        //self.sonarView.reloadData()
                                                    }
                                                })
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                            //fourth
                            query4?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: Double(1) / 2).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                            
                            query4?.findObjectsInBackground(block: {(objects, error) in
                                
                                if error != nil {
                                    print(error!)
                                } else if let users = objects {
                                    
                                    self.memberNameLineFour.removeAll()
                                    self.memberIDLineFour.removeAll()
                                    self.memberPicLineFour.removeAll()
                                    
                                    
                                    //                                        self.sonarView.reloadData()
                                    
                                    for object in users {
                                        if let user = object as? PFUser {
                                            
                                            if let blockedUsers = PFUser.current()?["blocked"] {
                                                if ( blockedUsers as AnyObject).contains(user.objectId! as String!) || self.memberIDLineOne.contains(user.objectId! as String!) || self.memberIDLineTwo.contains(user.objectId! as String!) || self.memberIDLineThree.contains(user.objectId! as String!) {
                                                    
                                                } else {
                                                    let imageFile = user["mainPhoto"] as! PFFile
                                                    
                                                    imageFile.getDataInBackground(block: {(data, error) in
                                                        
                                                        if let imageData = data {
                                                            self.memberPicLineFour.append(UIImage(data: imageData)!)
                                                            
                                                            self.memberNameLineFour.append(user.username!)
                                                            self.memberIDLineFour.append(user.objectId!)
                                                            
                                                            //self.sonarView.reloadData()
                                                        }
                                                    })
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                }
                                
                            })
                            //end fourth
                            
                        })
                        //end third
                        
                        
                    })
                    //end second
                    
                })
                
                //end first
            }
//            sonarView.reloadData()
        }
        
        
        
    }
    
    @IBAction func reloadData(_ sender: AnyObject) {
        sonarView.reloadData()
    }
}

// must be internal or public.


extension EchoSonarViewController: SonarViewDataSource {
    
    func numberOfWaves(sonarView: SonarView) -> Int {
        
        
        return 4
    }
    
    func sonarView(sonarView: SonarView, numberOfItemForWaveIndex waveIndex: Int) -> Int {
        switch waveIndex {
        case 0:
            return memberPicLineOne.count
        case 1:
            return memberPicLineTwo.count
        case 2:
            return memberPicLineThree.count
        default:
            return memberPicLineFour.count
        }
    }
    
    func sonarView(sonarView: SonarView, itemViewForWave waveIndex: Int, atIndex: Int) -> SonarItemView {
        let itemView = self.newItemView()
        
        switch waveIndex {
        case 0:
            itemView.imageView.image = memberPicLineOne[atIndex]
            break
        case 1:
            itemView.imageView.image = memberPicLineTwo[atIndex]
            break
        case 2:
            itemView.imageView.image = memberPicLineThree[atIndex]
            break
        case 3:
            itemView.imageView.image = memberPicLineFour[atIndex]
            break
        default:
            itemView.imageView.image = memberPicLineOne[atIndex]
            break
        }

        
        return itemView
    }
    
    // MARK: - Helpers
    
    fileprivate func randomAvatar() -> UIImage {
        let index = arc4random_uniform(3) + 1
        return UIImage(named: "default_user_image.png")!
    }
    
    fileprivate func newItemView() -> EchoSonarItemView {
        return Bundle.main.loadNibNamed("EchoSonarItemView", owner: self, options: nil)!.first as! EchoSonarItemView
    }
}

extension EchoSonarViewController: SonarViewDelegate {
    
    
    func sonarView(sonarView: SonarView, didSelectObjectInWave waveIndex: Int, atIndex: Int) {
        print("Did select item in wave \(waveIndex) at index \(atIndex)")
        switch waveIndex {
        case 0:
            displayedUserID = memberIDLineOne[atIndex]
            performSegue(withIdentifier: "toUserDetails", sender: self)

            break
        case 1:
            displayedUserID = memberIDLineTwo[atIndex]
            performSegue(withIdentifier: "toUserDetails", sender: self)

            break
        case 2:
            displayedUserID = memberIDLineThree[atIndex]
            performSegue(withIdentifier: "toUserDetails", sender: self)

            break
        case 3:
            displayedUserID = memberIDLineFour[atIndex]
            performSegue(withIdentifier: "toUserDetails", sender: self)

            break
        default:
            displayedUserID = memberIDLineOne[atIndex]
            performSegue(withIdentifier: "toUserDetails", sender: self)

            break
        }
    }
    
    func sonarView(sonarView: SonarView, textForWaveAtIndex waveIndex: Int) -> String? {
        
        if self.sonarView(sonarView: sonarView, numberOfItemForWaveIndex: waveIndex) % 2 == 0 {
            return self.distanceFormatter.string(fromDistance: 200.0 * Double(waveIndex + 1))
        } else {
            return nil
        }
    }
}


func delay(_ delay: Double, closure: @escaping (Void) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
