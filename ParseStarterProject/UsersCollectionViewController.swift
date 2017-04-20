
//
//  UsersCollectionViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "Cell"



class UsersCollectionViewController: UICollectionViewController {
    
    @IBOutlet var UserTableView: UICollectionView!
    
    var usernames = [""]
    var userID = [""]
    
    var userIdent = ""
    
    var images = [UIImage]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UsersCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: {(objects, error) in
            
            if error != nil {
                print(error)
            } else if let users = objects {
                
                self.usernames.removeAll()
                self.userID.removeAll()
                self.images.removeAll()
                
                for object in users {
                    if let user = object as? PFUser {

                        self.usernames.append(user.username!)
                        self.userID.append(user.objectId!)
                        
                        let imageFile = user["mainPhoto"] as! PFFile
                        
                        imageFile.getDataInBackground(block: {(data, error) in
                            
                            if let imageData = data {
                                self.images.append(UIImage(data: imageData)!)
                                
                                self.UserTableView.reloadData()
                            }
                        })
                    
                        
                    }
                }
            }
            
            self.collectionView?.reloadData()
            
        })

        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toUserDetails" {
//            let secondViewController = segue.destination as! UserDetailViewController
//            
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UsersCollectionViewCell
    
        // Configure the cell
        
        cell.ProfilePics.image = images[indexPath.item]
        
        cell.userID = userID[indexPath.item]
        
        print(cell.userID)
        
        cell.awakeFromNib()
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! UsersCollectionViewCell
        
        displayedUserID = cell.userID
        print(cell.userID)
        performSegue(withIdentifier: "toUserDetails", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    */
    
    @IBAction func logout(_ sender: Any) {
        
        PFUser.logOut()
        
        //        currentUser = PFUser.current()!.username
        
        performSegue(withIdentifier: "LogInScreen", sender: self)
        
    }

}
