//
//  UserDetailViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailViewController: UIViewController {

    @IBOutlet var profileImage: UIImageView!
    
    func menuBarButtonItemClicked() {
        performSegue(withIdentifier: "toUserList", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(displayedUserID)
        
        profileImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 4 )

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        profileImage.isUserInteractionEnabled = true
        
        profileImage.addGestureRecognizer(gesture)
        
//        PFGeoPoint.geoPointForCurrentLocation(inBackground: {(geopoint, error) in
//        
//            print(geopoint)
//            
//            if let geopoint = geopoint {
//                PFUser.current()?["location"] = geopoint
//                
//                PFUser.current()?.saveInBackground()
//            }
//        })
        
        updateImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        updateImage()
        
       profileImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 4 ) 
    }

    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        print("Was dragged")
        
        let translation = gestureRecognizer.translation(in: view)
        
        let profileImg = gestureRecognizer.view!
        
        profileImg.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 4 + translation.y)
        
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
