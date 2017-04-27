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
    @IBOutlet weak var about: UITextView!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    @IBOutlet var navBarItem: UINavigationItem!
    
    var favorite = Bool()
    
    var interstitial: GADInterstitial!
    
    
    func menuBarButtonItemClicked() {
        performSegue(withIdentifier: "toUserList", sender: self)
    }
    
    @IBAction func messageClicked(_ sender: Any) {
        
        showAd()
    }
    
    @IBAction func favorites_clicked(_ sender: Any) {
        
        if favorite == true {
            
            PFUser.current()?.removeObjects(in: [displayedUserID], forKey: "favorites")
            
            PFUser.current()?.saveInBackground(block: {(success, error) in
                
            })
            
            let query = PFUser.query()
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error != nil {
                    
                } else if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            if let favorites = PFUser.current()?["favorites"] {
                                if (favorites as AnyObject).contains(displayedUserID as String!) {
                                    self.favorite = true
                                    self.favoriteButton.title = "UnFavorite"
                                } else {
                                    self.favorite = false
                                    self.favoriteButton.title = "Favorite"
                                }
                            }
                        }
                    }
                }
            })
            
            favorite = false
        
        } else {
            
            PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: "favorites")
            
            PFUser.current()?.saveInBackground(block: {(success, error) in
                
            })
            
            let query = PFUser.query()
            
            query?.findObjectsInBackground(block: { (objects, error) in
                if error != nil {
                    
                } else if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            if let favorites = PFUser.current()?["favorites"] {
                                if (favorites as AnyObject).contains(displayedUserID as String!) {
                                    self.favorite = true
                                    self.favoriteButton.title = "UnFavorite"
                                } else {
                                    self.favorite = false
                                    self.favoriteButton.title = "Favorite"
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
        
        
        
        print(displayedUserID)
        

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        profileImage.isUserInteractionEnabled = true
        
        profileImage.addGestureRecognizer(gesture)
        
        updateImage()
        
        profileImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 4 )
        
        profileImage.alpha = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        updateImage()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
            
            } else if let users = objects {
                for object in users {
                    if let user = object as? PFUser {
                        if let favorites = PFUser.current()?["favorites"] {
                            if (favorites as AnyObject).contains(displayedUserID as String!) {
                                self.favorite = true
                                self.favoriteButton.title = "UnFavorite"
                            } else {
                                self.favorite = false
                                self.favoriteButton.title = "Favorite"
                            }
                        }
                    }
                }
            }
        })
        
    
       profileImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 4 )
        
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
                tracking = "unflirt"
                updateImage()
                
            } else if profileImg.center.x > self.view.bounds.width - 100 {
                print("chosen")
                tracking = "flirt"
                
                
            }
            
            if tracking != "" && displayedUserID != "" && tracking != "unflirt" {
                
                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: tracking)
                
                PFUser.current()?.saveInBackground(block: {(success, error) in
                   
                })
                    
                
            } else if tracking == "unfavorite" {
                PFUser.current()?.removeObjects(in: [displayedUserID], forKey: "flirt")
                
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
                            self.ageTag.text = user["age"] as? String
                            self.ethnicityTag.text = user["ethnicity"] as? String
                            self.maritalTag.text = user["marital"] as? String
                            self.heightTag.text = user["height"] as? String
                            self.weightTag.text = user["weight"] as? String
                            self.bodyTag.text = user["body"] as? String
                            self.about.text = user["about"] as? String
                        
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
