//
//  UserDetailViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import Firebase
import GoogleMobileAds

class UserDetailViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var ageTag: UILabel!
    @IBOutlet var locationTag: UILabel!
    @IBOutlet var maritalTag: UILabel!
    @IBOutlet var heightTag: UILabel!
    @IBOutlet var weightTag: UILabel!
    @IBOutlet var bodyTag: UILabel!
    @IBOutlet var ethnicityTag: UILabel!
    
    var interstitial: GADInterstitial!
    
    
    func menuBarButtonItemClicked() {
        performSegue(withIdentifier: "toUserList", sender: self)
    }
    
    @IBAction func messageClicked(_ sender: Any) {
        
        showAd()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(displayedUserID)
        
        profileImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 4 )

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        profileImage.isUserInteractionEnabled = true
        
        profileImage.addGestureRecognizer(gesture)
        
        updateImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        updateImage()
        
       profileImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 4 )
        

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


    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        print("Was dragged")
        
        let translation = gestureRecognizer.translation(in: view)
        
        let profileImg = gestureRecognizer.view!
        
        profileImg.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 4)
        
        let xFromCenter = profileImg.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretch = rotation.scaledBy(x: scale, y: scale)
        
        profileImg.transform = stretch
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var tracking = ""
            
            if profileImg.center.x < 100 {
                print("not chosen")
                tracking = "unfavorite"
                updateImage()
                
            } else if profileImg.center.x > self.view.bounds.width - 100 {
                print("chosen")
                tracking = "favorites"
                
                
            }
            
            if tracking != "" && displayedUserID != "" && tracking != "unfavorite" {
                
                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: tracking)
                
                PFUser.current()?.saveInBackground(block: {(success, error) in
                   
                })
                    
                
            } else if tracking == "unfavorite" {
                PFUser.current()?.removeObjects(in: [displayedUserID], forKey: "favorites")
                
                PFUser.current()?.saveInBackground(block: {(success, error) in
                    
                })
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretch = rotation.scaledBy(x: 1, y: 1)
            
            profileImg.transform = stretch
            
            profileImg.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 4 )
        }
    }
    
    func updateImage() {
    
        let query = PFUser.query()
        
        //query?.whereKey("username", equalTo: "1")
        
//        var blockedUsers = [""]
//        
//        if let favoriteUsers = PFUser.current()?["favorites"] {
//            blockedUsers += favoriteUsers as! Array
//        }
//        
//        if let rejectedUsers = PFUser.current()?["blocked"] {
//            blockedUsers += rejectedUsers as! Array
//        }
        
        query?.whereKey("objectId", equalTo: displayedUserID)
        
//        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
//            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
//                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
//            }
//        }
      
        query?.findObjectsInBackground(block: {(objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFUser {
                        
                            let imageFile = user["mainPhoto"] as! PFFile
                            
                            imageFile.getDataInBackground(block: {(data, error) in
                                
                                if let imageData = data {
                                    self.profileImage.image = UIImage(data: imageData)
                                }
                            })
                            self.ageTag.text = user["age"] as? String
                            self.ethnicityTag.text = user["ethnicity"] as? String
                            self.maritalTag.text = user["marital"] as? String
                            self.heightTag.text = user["height"] as? String
                            self.weightTag.text = user["weight"] as? String
                            self.bodyTag.text = user["body"] as? String
                    }
                }
            }
        })
        
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
