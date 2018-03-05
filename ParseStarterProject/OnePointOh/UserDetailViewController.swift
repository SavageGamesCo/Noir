//
//  UserDetailViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import Firebase
import GoogleMobileAds
import UserNotifications
import MapKit
import Spring

var currentLocation = NSString()

class UserDetailViewController: UITableViewController, UINavigationControllerDelegate {
    
    var currentLocation = NSString()
    
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    
    private var subscription: Subscription<PFObject>!

    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet weak var bannerAd: GADBannerView!
    
    @IBOutlet weak var locationTag: UILabel!
    @IBOutlet var ageTag: UILabel!
    @IBOutlet var maritalTag: UILabel!
    @IBOutlet var heightTag: UILabel!
    @IBOutlet var weightTag: UILabel!
    @IBOutlet var bodyTag: UILabel!
    @IBOutlet var ethnicityTag: UILabel!
    @IBOutlet weak var about: UITextView!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var chatButton: UIBarButtonItem!
    
    @IBOutlet weak var blockButton: UIBarButtonItem!
    @IBOutlet var navBarItem: UINavigationItem!
    
    var favorite = Bool()
    
    var username = ""
    
    var interstitial: GADInterstitial!
    
    
    func menuBarButtonItemClicked() {
        performSegue(withIdentifier: "toUserList", sender: self)
    }
    
    @IBAction func messageClicked(_ sender: Any) {
        
        showAd()
    }
    
    @IBAction func blockUserClicked(_ sender: Any) {
        
        commonActionSheet(title: "Block Member", message: "Are you certain you wish to block this user?", whatCase: "block")
        
    }
    
    @IBAction func reportButtonClicked(_ sender: Any) {
        commonActionSheet(title: "Report User", message: "Are you certain you wish to report this user? Bear in mind reporting a user is to be used in cases of harassment, cyber bullying, doxxing and violations of Noir profile rules. To validate a violation a profile must do one of the following:\n\n * Display Nudity\n\n * Contain Racist Language\n\n * Display a False Picture (no catfishing)\n\n * Contain OVERLY Vulgar Language\n\n * Promotes ANY Crime\n\n * Participate in Cyber Stalking/Cyber Bullying/Harrassment.\n\n\n **REPORTING A USER WILL ALSO BLOCK THIS USER** ", whatCase: "report")
    
    }
    
    @IBAction func favorites_clicked(_ sender: Any) {
        
        if favorite == true {
            
            PFUser.current()?.removeObjects(in: [displayedUserID], forKey: "favorites")
            
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
                                if (favorites as AnyObject).contains(displayedUserID as String!) {
                                    self.favorite = true
//                                    self.favoriteButton.title = "UnFavorite"
                                    self.favoriteButton.tintColor = FAVORITE_BUTTON_COLOR_ON
                                    
                                } else {
                                    self.favorite = false
//                                    self.favoriteButton.title = "Favorite"
                                    self.favoriteButton.tintColor = FAVORITE_BUTTON_COLOR_OFF
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
            
            
            favoriteIcon.frame = CGRect(x: view.frame.size.width / 2, y: view.frame.size.height  / 2 , width: 600, height: 362)
            
            favoriteIcon.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2);
            
            self.view.addSubview(favoriteIcon)
            
            PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: "favorites")
            
            PFUser.current()?.saveInBackground(block: {(success, error) in
                
            })
            
            let query = PFUser.query()
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error != nil {
                    
                } else if let users = objects {
                    for object in users {
                        if object is PFUser {
                            if let favorites = PFUser.current()?["favorites"] {
                                if (favorites as AnyObject).contains(displayedUserID as String!) {
                                    self.favorite = true
//                                    self.favoriteButton.title = "UnFavorite"
                                    self.favoriteButton.tintColor = FAVORITE_BUTTON_COLOR_ON
                                } else {
                                    self.favorite = false
//                                    self.favoriteButton.title = "Favorite"
                                    self.favoriteButton.tintColor = FAVORITE_BUTTON_COLOR_OFF
                                }
                            }
                        }
                    }
                }
            })
            
            favorite = true
        
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.current()?["adFree"] as? Bool == false {
            if PFUser.current()?["membership"] as? String == "basic" {
                bannerAd.isHidden = false
                print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
                bannerAd.adUnitID = "ca-app-pub-9770059916027069/2101714155"
                bannerAd.rootViewController = self
                bannerAd.load(GADRequest())
            }
        } else if PFUser.current()?["adFree"] as? Bool == true || PFUser.current()?["membership"] as? String != "basic" {
            bannerAd.isHidden = true
        }
        
        
    
        let msgQuery = PFQuery(className: "Chat").whereKey("app", equalTo: APPLICATION).whereKey("toUser", contains: CURRENT_USER!)
        
        subscription = liveQueryClient.subscribe(msgQuery).handle(Event.created) { _, message in
            // This is where we handle the event
            
            
            
            if Thread.current != Thread.main {
                return DispatchQueue.main.async {
                    
                     
//                    self.notification(displayName: message["senderName"] as! String)
//                    UIApplication.shared.applicationIconBadgeNumber = badge
//                    print("Got new message")
                    
                }
            } else {
                
                 
//                self.notification(displayName: message["senderName"] as! String)
//                UIApplication.shared.applicationIconBadgeNumber = badge
//                print("Got new message")
            }
            
        }
        
        if displayedUserID == PFUser.current()?.objectId {
            chatButton.isEnabled = false
            blockButton.isEnabled = false
            favoriteButton.isEnabled = false
        } else {
            chatButton.isEnabled = true
            blockButton.isEnabled = true
            favoriteButton.isEnabled = true
        }
        
        
        
//        print(displayedUserID)
        

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        profileImage.isUserInteractionEnabled = true
        
        profileImage.addGestureRecognizer(gesture)
        
        updateImage()
        
        profileImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.profileImage.center.y )
        
        profileImage.alpha = 1
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        
//        updateImage()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
            
            } else if let users = objects {
                for object in users {
                    if object is PFUser {
                        if let favorites = PFUser.current()?["favorites"] {
                            if (favorites as AnyObject).contains(displayedUserID as String!) {
                                self.favorite = true
//                                self.favoriteButton.title = "UnFavorite"
                                self.favoriteButton.tintColor = FAVORITE_BUTTON_COLOR_ON
                            } else {
                                self.favorite = false
//                                self.favoriteButton.title = "Favorite"
                                self.favoriteButton.tintColor = FAVORITE_BUTTON_COLOR_OFF
                            }
                        }
                    }
                }
            }
        })
        
    
       profileImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.profileImage.center.y )
        
        profileImage.alpha = 1
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func showAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    fileprivate func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9770059916027069/7359406151")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
    }


    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let profileImg = gestureRecognizer.view!
        
        profileImg.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.profileImage.center.y)
        
        let xFromCenter = profileImg.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretch = rotation.scaledBy(x: scale, y: scale)
        
        profileImg.transform = stretch
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var tracking = String()
            
            if profileImg.center.x < 100 {
                print("not chosen")
                tracking = "unflirt"
                let unflirtGraphic = SpringImageView()
                
                unflirtGraphic.image = UIImage(named: "unflirt_2.png")
                unflirtGraphic.contentMode = .scaleAspectFill
                //flirtGraphic.y = -50
                unflirtGraphic.autostart = true
                unflirtGraphic.animation = "zoomIn"
                unflirtGraphic.animateToNext {
                    unflirtGraphic.animation = "zoomOut"
                    unflirtGraphic.animateTo()
                    
                }
                
                
                unflirtGraphic.frame = CGRect(x: (self.view.window?.center.x)! / 4, y: (self.view.window?.center.y)! / 4, width: 300, height: 300)
                
                unflirtGraphic.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2);
                
                self.view.addSubview(unflirtGraphic)
                
                PFUser.current()?.removeObjects(in: [displayedUserID], forKey: "flirt")
                
                PFUser.current()?.saveInBackground(block: {(success, error) in
                    print("Flirt with " + displayedUserID + "removed")
                })
                
                
            } else if profileImg.center.x > self.view.bounds.width - 100 {
                print("chosen")
                
                if PFUser.current()?["membership"] as? String != "basic" {
                    if let flirt = PFUser.current()?["flirt"] as? NSArray {
                        
                        let flirtlimit = PFUser.current()?["flirtLimit"] as! Int
                        
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
                        
                        
                        flirtGraphic.frame = CGRect(x: (self.view.window?.center.x)! / 4, y: (self.view.window?.center.y)! / 4, width: 300, height: 300)
                        
                        flirtGraphic.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2);
                        
                        self.view.addSubview(flirtGraphic)
                        
                        PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: tracking)
                        
                        PFUser.current()?.saveInBackground(block: {(success, error) in
                            
                            print("Flirt with " + displayedUserID + "added")
                        })
                        
                        sendFlirt()
                        
                        
                    }
                
                }else{
                    if let flirt = PFUser.current()?["flirt"] as? NSArray {
                        
                        let flirtlimit = PFUser.current()?["flirtLimit"] as! Int
                        
                        
                        print(flirtlimit)
                        
                        
                        if (flirt.count)  < flirtlimit {
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
                            
                            
                            flirtGraphic.frame = CGRect(x: (self.view.window?.center.x)! / 4, y: (self.view.window?.center.y)! / 4, width: 300, height: 300)
                            
                            flirtGraphic.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2);
                            
                            self.view.addSubview(flirtGraphic)
                            
                            PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: tracking)
                            
                            PFUser.current()?.saveInBackground(block: {(success, error) in
                                
                                print("Flirt with " + displayedUserID + "added")
                            })
                            
                            sendFlirt()
                            
                            
                        } else {
                            
                            self.dialogueBox(title: "Flirt Limit Reached", messageText: "You have reached your flirt limit. Visit the in-app store to learn how to get unlimited flirts, local members and global members.")
                        }
                        
                    }
                
                }
                
                

                
                
            }
            
//            if tracking != "" && displayedUserID != "" && tracking != "unflirt" {
//                
//                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: tracking)
//                
//                PFUser.current()?.saveInBackground(block: {(success, error) in
//                
//                   
//                })
//                    
//                
//            } else if tracking == "unflirt" {
//                PFUser.current()?.removeObjects(in: [displayedUserID], forKey: "flirt")
//                
//                PFUser.current()?.saveInBackground(block: {(success, error) in
//                    
//                })
//            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretch = rotation.scaledBy(x: 1, y: 1)
            
            profileImg.transform = stretch
            
            profileImg.center = CGPoint(x: self.view.bounds.width / 2, y: self.profileImage.center.y )
        }
    }
    
    func sendFlirt(){
        
        var installationID = PFInstallation()
        do {
            let user = try PFQuery.getUserObject(withId: displayedUserID)
            if user["installation"] != nil {
                installationID = (user["installation"] as? PFInstallation)!
            }
        }catch{
            print("No User Selected")
        }
        
        PFCloud.callFunction(inBackground: "sendPushToUserTest", withParameters: ["recipientId": displayedUserID, "chatmessage": "\(PFUser.current()!.username!) has flirted with you", "installationID": installationID.objectId as Any], block: { (object: Any?, error: Error?) in
            
            if error != nil {
                print(error!)
            } else {
    
                print("PFCloud push was successful")
            }
            
        })
        
    }
    
    func updateImage() {
    
        let query = PFUser.query()
        
        query?.whereKey("objectId", equalTo: displayedUserID)
        
      
        query?.findObjectsInBackground(block: {(objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFUser {
                        
                            self.navBarItem.title = user.username
                        
                            let imageFile = user["mainPhoto"] as! PFFile
                            
                            imageFile.getDataInBackground(block: {(data, error) in
                                
                                if let imageData = data {
                                    self.profileImage.image = UIImage(data: imageData)
                                }
                            })
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
                                    
                                    // City
                                    if let city = placeMark.addressDictionary!["City"] as? NSString {
                                        print(city)
                                        // Country
                                        if let state = placeMark.addressDictionary!["State"] as? NSString {
                                            print(state)
                                            
                                            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                                                print(country)
                                                
                                                self.currentLocation = ((city as NSString) as String) + ", " + ((state as NSString) as String) + " " + ((country as NSString) as String) as NSString
                                                
                                                print(self.currentLocation)
                                                
                                                self.locationTag.text = self.currentLocation as String
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    
                                })
                                
                                //end get location
                            }
                        }
                        
                        
                            self.ageTag.text = user["age"] as? String
                            self.ethnicityTag.text = user["ethnicity"] as? String
                            self.maritalTag.text = user["marital"] as? String
                            self.heightTag.text = user["height"] as? String
                            self.weightTag.text = user["weight"] as? String
                            self.bodyTag.text = user["body"] as? String
                            self.about.text = user["about"] as? String
                            self.username = user.username!
                        
                    }
                }
            }
        })
        
        
        
        
    }
    
    func dialogueBoxFlirt(title:String, messageText:String ){
        let dialog = UIAlertController(title: title,
                                       message: messageText,
                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialog.addAction(defaultAction)
        // Present the dialog.
        
        func sendFlirt(){
            PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: ["recipientId": displayedUserID, "chatmessage": "\(PFUser.current()!.username!) has flirted with you"], block: { (object: Any?, error: Error?) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("PFCloud push was successful")
                }
                
            })
            
        }
        
        self.present(dialog,
                     animated: true,
                     completion: sendFlirt)
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func notification(displayName: String){
        
//        let chatNotification = UNMutableNotificationContent()
//        chatNotification.title = "Noir Chat Notification"
//        chatNotification.body = "You Have a New Chat message from " + displayName
//        chatNotification.badge = badge as NSNumber
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier:APPLICATION, content: chatNotification, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func commonActionSheet(title: String, message: String, whatCase: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        
        switch whatCase {
        case "delUser":
            let delete = UIAlertAction(title: "Delete", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(delete)
            alert.addAction(cancel)
            break
        case "block":
            let block = UIAlertAction(title: "Block", style: .default, handler: {(alert: UIAlertAction!) in self.blockUser()} )
            let cancel = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(block)
            alert.addAction(cancel)
            break
        case "report":
            let report = UIAlertAction(title: "report", style: .default, handler: {(alert: UIAlertAction!) in self.reportUser()} )
            let cancel = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(report)
            alert.addAction(cancel)
            break
        case "normal":
            let cancel = UIAlertAction(title: "Close", style: .cancel, handler: nil)
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
    
    func blockUser() {
        PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: "blocked")
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            if error != nil {
                print("Error saving after blocking user")
            } else {
                self.performSegue(withIdentifier: "toUserTable", sender: self)
            }
            
        })
    }
    
    func reportUser() {
        PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: "blocked")
        
        let reported = PFObject(className: "Reported")
        
        reported["reportedBy"] = PFUser.current()?.objectId
        reported["reportedByUserName"] = PFUser.current()?.username
        reported["reportedUser"] = displayedUserID 
        reported["reportedUserUsername"] = username 
        
        reported.saveInBackground { (success, error) in
            
            if error != nil {
                print("error in reporting user")
            } else {
                print("user reported")
                self.dialogueBox(title: "User Blocked", messageText: "You have Blocked " + self.username + ".")
            }
        }
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            if error != nil {
                print("Error saving after blocking user")
            } else {
                print("user reported")
                self.performSegue(withIdentifier: "toUserTable", sender: self)
            }
            
        })

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
