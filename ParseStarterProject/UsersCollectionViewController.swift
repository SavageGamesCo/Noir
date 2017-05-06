
//
//  UsersCollectionViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import Firebase
import GoogleMobileAds

private let reuseIdentifier = "Cell"



class UsersCollectionViewController: UICollectionViewController, UIToolbarDelegate {
    
    @IBOutlet var UserTableView: UICollectionView!
    
    var usernames = [String]()
    var userID = [String]()
    var online = [String]()
    
    var withinDistance = 10
    
    var userIdent = String()
    
    var images = [UIImage]()
    
    var showUser = "AUser"
    
    var interstitial: GADInterstitial!
    
    let refreshControl = UIRefreshControl()
    
    let onlineColor = UIColor(colorLiteralRed: 0.988, green: 0.685, blue: 0.000, alpha: 1.0)
    let offlineColor = UIColor(colorLiteralRed: 0.647, green: 0.647, blue: 0.647, alpha: 1.0)
    
    

    @IBAction func auserClicked(_ sender: Any) {
        if showUser != "AUser" {
            showUser = "AUser"
            UserView()
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        } else {
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        
    }

    @IBAction func lusrClicked(_ sender: Any) {
        if showUser != "LUser" {
            showUser = "LUser"
            UserView()
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        } else {
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        
    }
    
    @IBAction func favsClicked(_ sender: Any) {
        if showUser != "Fave" {
            showUser = "Fave"
            UserView()
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            
        } else {
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    
    @IBAction func flirtsClicked(_ sender: Any) {
        if showUser != "Flirts" {
            showUser = "Flirts"
            UserView()
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            
        } else {
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }

    }
  
    @IBAction func messagesClicked(_ sender: Any) {
        
        self.showAd()
        
        performSegue(withIdentifier: "toMsgList", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonActionSheet(title: "Safety Statement", message: "Please be careful when meeting people from the internet in real life. Practice basic safety such as meeting in public, informing someone you trust of your whereabouts. Practice safety at all times. Be sure to ask the pertinent questions before engaging in risky behavior.")
        
        UserTableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(UsersCollectionViewController.auserClicked(_:)), for: .touchDown)
        refreshControl.addTarget(self, action: #selector(UsersCollectionViewController.lusrClicked(_:)), for: .touchDown)
        refreshControl.addTarget(self, action: #selector(UsersCollectionViewController.favsClicked(_:)), for: .touchDown)
        
                geoPoint()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UsersCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        UserView()
        // Do any additional setup after loading the view.

       self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.createAndLoadInterstitial()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        geoPoint()
        
        self.UserTableView.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        geoPoint()
        
        self.interstitialDidDismissScreen(createAndLoadInterstitial())
        
        self.UserTableView.reloadData()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
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
    
    func geoPoint(){
        
        PFGeoPoint.geoPointForCurrentLocation(inBackground: {(geopoint, error) in
            
            print(geopoint!)
            if let geopoint = geopoint {
                PFUser.current()?["location"] = geopoint
                
                PFUser.current()?.saveInBackground()
            }
        })

    }
    
    func showAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self as? GADInterstitialDelegate
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func UserView(){
    
        switch showUser {
        case "AUser":
            let query = PFUser.query()
            
            query?.whereKey("online", equalTo: true as NSNumber)
            //Show All Users
            query?.findObjectsInBackground(block: {(objects, error) in
                
                if error != nil {
                    print(error!)
                } else if let users = objects {
                    
                    self.usernames.removeAll()
                    self.userID.removeAll()
                    self.images.removeAll()
                    self.online.removeAll()
                    
                    self.UserTableView.reloadData()
                    
                    for object in users {
                        if let user = object as? PFUser {
                            
                            
                            let imageFile = user["mainPhoto"] as! PFFile
                            
                            imageFile.getDataInBackground(block: {(data, error) in
                                
                                if let imageData = data {
                                    self.images.append(UIImage(data: imageData)!)
                                    
                                    self.usernames.append(user.username!)
                                    self.userID.append(user.objectId!)
                                    self.online.append(user.objectId!)
                                    
                                    self.UserTableView.reloadData()
                                }
                            })

                            
                            
                        }
                    }
                }
                
            })
            break
        case "LUser":
            let query = PFUser.query()
            //Show Local Users
            if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
                if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                    
                    query?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: Double(self.withinDistance))
                    query?.whereKey("online", equalTo: true as NSNumber)
                    
                    query?.findObjectsInBackground(block: {(objects, error) in
                        
                        if error != nil {
                            print(error!)
                        } else if let users = objects {
                            
                            self.usernames.removeAll()
                            self.userID.removeAll()
                            self.images.removeAll()
                            self.online.removeAll()
                            
                            self.UserTableView.reloadData()
                            
                            for object in users {
                                if let user = object as? PFUser {
                                    
                                    
                                    let imageFile = user["mainPhoto"] as! PFFile
                                    
                                    imageFile.getDataInBackground(block: {(data, error) in
                                        
                                        if let imageData = data {
                                            self.images.append(UIImage(data: imageData)!)
                                            
                                            self.usernames.append(user.username!)
                                            self.userID.append(user.objectId!)
                                            self.online.append(user.objectId!)
                                            
                                            
                                            self.UserTableView.reloadData()
                                        }
                                    })
                                    
                                }
                            }
                        }
                      
                    })
                }
            }
            break
        case "Fave":
            let query = PFUser.query()
            //Show Favorites
            query?.findObjectsInBackground(block: {(objects, error) in
                
                if error != nil {
                    print(error!)
                } else if let users = objects {
                    
                    
                    self.usernames.removeAll()
                    self.userID.removeAll()
                    self.images.removeAll()
                    self.online.removeAll()

                    
                    for object in users {
                        if let user = object as? PFUser {
                            
                            if let favoriteUsers = PFUser.current()?["favorites"] {
                                if (favoriteUsers as AnyObject).contains(user.objectId! as String!){
                                    
                                    let imageFile = user["mainPhoto"] as! PFFile
                                    
                                    imageFile.getDataInBackground(block: {(data, error) in
                                        
                                        if let imageData = data {
                                            self.images.append(UIImage(data: imageData)!)
                                            
                                            self.usernames.append(user.username!)
                                            self.userID.append(user.objectId!)
                                            
                                            if user["online"] as! Bool {
                                                self.online.append(user.objectId!)
                                            } else {
//                                                self.online.append("offline")
                                            }
                                            
                                            self.UserTableView.reloadData()
                                            
                                        }
                                    })
                                    
                                }
                                
                            }
                        }
                    }
                }
                
            })
            
            break
        case "Flirts":
            let query = PFUser.query()
            //Show Favorites
            query?.findObjectsInBackground(block: {(objects, error) in
                
                if error != nil {
                    print(error!)
                } else if let users = objects {
                    
                    self.usernames.removeAll()
                    self.userID.removeAll()
                    self.images.removeAll()
                    self.online.removeAll()
                    
                    self.UserTableView.reloadData()
                    
                    for object in users {
                        if let user = object as? PFUser {
                            
                            if let userFlirts = user["flirt"] {
                                if (userFlirts as AnyObject).contains(PFUser.current()?.objectId! as String!){
                                    
                                    let imageFile = user["mainPhoto"] as! PFFile
                                    
                                    imageFile.getDataInBackground(block: {(data, error) in
                                        
                                        if let imageData = data {
                                            self.images.append(UIImage(data: imageData)!)
                                            
                                            self.usernames.append(user.username!)
                                            self.userID.append(user.objectId!)
                                            
                                            if user["online"] as! Bool {
                                                self.online.append(user.objectId!)
                                            } else {
                                                //                                                self.online.append("offline")
                                            }
                                            
                                            self.UserTableView.reloadData()
                                            
                                        }
                                    })
                                    
                                }
                                
                            }
                        }
                    }
                }
                
            })
            
            break
        default:
            break
        }
        
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
        
        cell.ProfilePics.image = images[indexPath.item]
        
        cell.userID = userID[indexPath.item]
        
        cell.userName.text = usernames[indexPath.item]
        
        if online.contains(cell.userID) {
            cell.ProfilePics.layer.borderColor = onlineColor.cgColor
        } else {
            cell.ProfilePics.layer.borderColor = offlineColor.cgColor
            
        }
        
        cell.layer.shadowOpacity = 0.6
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        
        cell.awakeFromNib()
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! UsersCollectionViewCell
        
        displayedUserID = cell.userID
        
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
    
    func commonActionSheet(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.popoverPresentationController?.sourceView = view
        
        present(alert, animated: true, completion: nil)
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
        
        
    }

}
