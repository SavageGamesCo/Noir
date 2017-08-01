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
    
    
    @IBOutlet weak var echo_title_bar: UINavigationItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var range = "short"
    
    @IBOutlet weak var LongRangeButton: UIBarButtonItem!
    @IBOutlet weak var ShortRangeButton: UIBarButtonItem!
    
    @IBAction func shortRangePressed(_ sender: Any) {
        
        if range != "short" {
            range = "short"
            
            ShortRangeButton.isEnabled = false
            LongRangeButton.isEnabled = true
            echo_title_bar.title = "Echo: Short Range"
            
            if PFUser.current()?["membership"] as! String == "basic" {
                dialogueBox(title: "INCREASE YOUR RESULTS!!", messageText: "Increase the number of Short Range Echo hits with a monthly subscription! Visit the shop page for more info on membership perks.")
            }
            
        }
        
    }
    @IBAction func longRangePressed(_ sender: Any) {
        
        if range != "long" {
            range = "long"
            
            LongRangeButton.isEnabled = false
            ShortRangeButton.isEnabled = true
            echo_title_bar.title = "Echo: Long Range"
            
            if PFUser.current()?["membership"] as! String == "basic" {
                dialogueBox(title: "INCREASE YOUR RESULTS", messageText: "Increase the number of Long Range Echo hits AND Increase your range to 20+ miles with a monthly subscription! Visit the shop page for more info on membership perks.")
            }
            
        }
        
    }
    
    
    
    var withinDistance = Int()
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SonarView.lineColor = ONLINE_COLOR
        SonarView.lineShadowColor = ONLINE_COLOR_2
        SonarView.distanceTextColor = ONLINE_COLOR
        
        sonarView.backgroundColor = UIColor.darkGray
        
        if range == "short" {
            ShortRangeButton.isEnabled = false
            LongRangeButton.isEnabled = true
            echo_title_bar.title = "Echo: Short Range"
        } else {
            LongRangeButton.isEnabled = false
            ShortRangeButton.isEnabled = true
            echo_title_bar.title = "Echo: Long Range"
        }
        
        geoPoint()

        self.sonarView.delegate = self as? SonarViewDelegate
        self.sonarView.dataSource = self as? SonarViewDataSource
        
        if PFUser.current()?["echo"] as? Bool != true {
            
            sonarView.isHidden = true
            LongRangeButton.isEnabled = false
            ShortRangeButton.isEnabled = false
            
            let label = UILabel()
            
            label.text = "Turn On Echo To Use Echo."
            label.textColor = ONLINE_COLOR
            label.numberOfLines = 2
            label.center.x = self.view.center.x / 2
            label.center.y = self.view.center.y
            label.sizeToFit()
            label.textAlignment = .center
            
            self.view.addSubview(label)
        
        } else {
            
            let bundle = Bundle.main
            let EchoFeaturePath = bundle.path(forResource: "echo_feature", ofType: "txt")
            let EchoWarningPath = bundle.path(forResource: "echo_warning", ofType: "txt")
            
            self.view.bringSubview(toFront: toolbar)
            
            self.navigationController?.setToolbarHidden(true, animated: true)
            
            var EchoFeatureText = String()
            var EchoWarningText = String()
            
            do{
                try EchoFeatureText = String(contentsOfFile: EchoFeaturePath!)
                try EchoWarningText = String(contentsOfFile: EchoWarningPath!)
                
            }catch{
                print("Unable to load privacy policy")
            }
            
            commonActionSheet(title: "Echo", message: EchoFeatureText + "\n\n" + EchoWarningText , whatCase: "normal")
//            commonActionSheet(title: "Echo - WARNING", message: EchoWarningText , whatCase: "normal")
//            update()
//            
//            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            
            
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        
        timer.invalidate()
        print("Timer invalidated")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopTimer() {
            timer.invalidate()
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
        
        geoPoint()
        
        sonarView.reloadData()
        
        // Something cool
        
        if range == "short" {
            //short range logic
            print("Short Range")
            let query = PFUser.query()
            let query2 = PFUser.query()
            let query3 = PFUser.query()
            let query4 = PFUser.query()
            
            if PFUser.current()?["membership"] as? String == "basic" {
                query?.limit = 10
                query2?.limit = 10
                query3?.limit = 10
                query4?.limit = 10
            }
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
        } else {
            
            if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
                if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                    var from = Double()
                    
                    //long range logic
                    print("Long Range")
                    let query = PFUser.query()
                    let query2 = PFUser.query()
                    let query3 = PFUser.query()
                    let query4 = PFUser.query()
                    
                    if PFUser.current()?["membership"] as? String != "basic" {
                        query?.limit = 10
                        query2?.limit = 10
                        query3?.limit = 10
                        query4?.limit = 10
                        
                        from = 22.0
                        
                        query?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: from / 3.9).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                        query2?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: from / 2).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                        query3?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: from / 1.23).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                        query4?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: from ).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                        
                        
                        
                    } else {
                        query?.limit = 4
                        query2?.limit = 4
                        query3?.limit = 4
                        query4?.limit = 4
                        
//                        from = PFUser.current()?["withinDistance"] as! Double
                        
                        from = 10
                        
                        query?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: from / 4).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                        query2?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: from / 2).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                        query3?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: from / 1.3).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                        query4?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: from ).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir").order(byAscending: "location")
                    }
                    
                    //Show Local Users
                    if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
                        if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                            
                            
                            
                            //first
                            
                            
                            
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
            }
            
        }
        
    }
    
    func commonActionSheet(title: String, message: String, whatCase: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        
        switch whatCase {
        
        case "normal":
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancel)
            break
        default:
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            break
        }
        
        
        
        alert.popoverPresentationController?.sourceView = view
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reloadData(_ sender: AnyObject) {
        sonarView.reloadData()
    }
    
    func dialogueBox(title:String, messageText:String ){
        let dialog = UIAlertController(title: title,
                                       message: messageText,
                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialog.addAction(defaultAction)
        // Present the dialog.
        
        self.present(dialog,
                     animated: true,
                     completion: nil)
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
            
            if range != "short" {
                
                //let from = PFUser.current()?["withinDistance"] as! Double
                
                if PFUser.current()?["membership"] as! String == "basic" {
                    print(self.distanceFormatter.string(fromDistance: 4000.0 * Double(waveIndex + 1)))
                    return self.distanceFormatter.string(fromDistance: 4000.0 * Double(waveIndex + 1))
                } else {
                    print(self.distanceFormatter.string(fromDistance: 9000 * Double(waveIndex + 1)))
                    return self.distanceFormatter.string(fromDistance: 9000 * Double(waveIndex + 1))
                }
            
            } else {
                return self.distanceFormatter.string(fromDistance: 200.0 * Double(waveIndex + 1))
            }
            
            
        } else {
            return nil
        }
    }
}




func delay(_ delay: Double, closure: @escaping (Void) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
