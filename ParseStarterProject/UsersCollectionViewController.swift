
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
import UserNotifications
import ParseLiveQuery
import StoreKit
import SwiftyStoreKit

private let reuseIdentifier = "Cell"

class UsersCollectionViewController: UICollectionViewController, UIToolbarDelegate {
    
    let bundleID = "comsavagecodeNoir"
    
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    
    private var subscription: Subscription<PFObject>!
    
    @IBOutlet var UserTableView: UICollectionView!
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var chatIcon: UIBarButtonItem!
    var usernames = [String]()
    var userID = [String]()
    var online = [String]()
    var blocked = [String]()
    
    
    
    var withinDistance = 10
    
    var activityIndicater = UIActivityIndicatorView()
    
    var userIdent = String()
    
    var images = [UIImage]()
    
    var showUser = "AUser"
    
    var interstitial: GADInterstitial!
    
    let refreshControl = UIRefreshControl()
    
    
    @IBAction func reload(_ sender: Any) {
        
        refreshing()
    }

    @IBAction func auserClicked(_ sender: Any) {
        if showUser != "AUser" {
            showUser = "AUser"
            UserView()
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()

            }
        } else {
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
            }
        }
        
        
    }

    @IBAction func lusrClicked(_ sender: Any) {
        if showUser != "LUser" {
            showUser = "LUser"
            UserView()
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                
            }
        } else {
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                
            }
        }
        
        
    }
    
    @IBAction func favsClicked(_ sender: Any) {
        if showUser != "Fave" {
            showUser = "Fave"
            UserView()
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                
            }
            
        } else {
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                
            }
        }
        
    }
    
    
    @IBAction func flirtsClicked(_ sender: Any) {
        if showUser != "Flirts" {
            showUser = "Flirts"
            UserView()
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                
            }
            
        } else {
            DispatchQueue.main.async {
                
                self.UserTableView.reloadData()
                
            }
        }

    }
    
    func refreshing(){
        UserView()
        self.UserTableView.reloadData()

    }
  
    @IBAction func messagesClicked(_ sender: Any) {
        
        self.showAd()
        
        self.chatIcon.tintColor = ONLINE_COLOR
        
        performSegue(withIdentifier: "toMsgList", sender: self)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    
                default:
                    print("Membership is active and not expired")
                    break
                }
                
            } else {
                // receipt verification error
            }
        }
        //end validate subscription
        
        var support_shown = false
        
        if PFUser.current()?["membership"] as? String == "basic" {
            if support_shown == false {
                self.commonActionSheet(title: "Support Noir!", message: "Noir is a mobile dating application for people of color and lovers of diversity within the gay community. \n\n Noir is not possible without the support of the community. With your support we can upgrade servers to provide a faster and smoother experience for you, we can add new features, we can staff technical support and we can continue to bring you a service made by us, for us. \n\n Noir is made available for free, ad supported, with restrictions. Please consider upgrading to the ad-free version of Noir to have the advertising removed for a one time cost.\n\n Consider one of Noir's monthly memberships to have an increased amount of members shown in the global view, increase the distance for finding local members, have an infinite amount of flirst and favorites! Your monthly subscription goes towards the monthly expenses to run Noir and as mentioned above, bringing you more features and an overall better product.\n\n Noir is not possible without the support of the community it was created for.")
                support_shown = true
            }
        }
        
        // This message query filters every incoming message that is
        // On the class 'Message' and has a 'message' field to a particular user
        let msgQuery = PFQuery(className: "Chat").whereKey("app", equalTo: APPLICATION).whereKey("toUser", contains: CURRENT_USER!)
        
        subscription = liveQueryClient.subscribe(msgQuery).handle(Event.created) { _, message in
            // This is where we handle the event
            
            DispatchQueue.main.async {
                self.chatIcon.tintColor = CHAT_ALERT_COLOR
                badge += 1
                self.notification(displayName: message["senderName"] as! String)
                print("Got new message")
                
            }
            
        }
        
        geoPoint()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //preloading the interstitial
        _ = self.createAndLoadInterstitial()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicater.center = self.view.center
        activityIndicater.hidesWhenStopped = true
        activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicater)
        activityIndicater.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        geoPoint()
        UserView()
        self.UserTableView.reloadData()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.interstitialDidDismissScreen(createAndLoadInterstitial())
        self.UserTableView.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
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

    }
    
    func showAd() {
        if PFUser.current()?["adFree"] as? Bool == false || PFUser.current()?["membership"] as? String != "basic" {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        } else {
            print("User is Ad Free.")
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9770059916027069/7359406151")
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
            self.navTitle.title = "Global"

            let query = PFUser.query()
            
            if PFUser.current()?["membership"] as? String == "basic" {
                
                query?.limit = PFUser.current()?["globalLimit"] as! Int
            }
            
            query?.whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir")
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
                            
                            if let blockedUsers = PFUser.current()?["blocked"] {
                                if (blockedUsers as AnyObject).contains(user.objectId! as String!){
                                    
                                } else {
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
                    }
                }
                
            })
            break
        case "LUser":
            self.navTitle.title = "Local"

            let query = PFUser.query()
            //Show Local Users
            if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
                if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                    
                    if PFUser.current()?["membership"] as? String == "basic" {
                        query?.limit = PFUser.current()?["globalLimit"] as! Int
                        withinDistance = (PFUser.current()?["localLimit"] as? Int)!
                    } else {
                        withinDistance = 100
                    }
                    
                    query?.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude) , withinMiles: Double(withinDistance)).whereKey("online", equalTo: true as NSNumber).whereKey("app", equalTo: "noir")
                    
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
                                    
                                    if let blockedUsers = PFUser.current()?["blocked"] {
                                        if ( blockedUsers as AnyObject).contains(user.objectId! as String!){
                                            
                                        } else {
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
                            }
                        }
                      
                    })
                }
            }
            break
        case "Fave":
            self.navTitle.title = "Favorites"
            
            self.UserTableView.reloadData()

            let query = PFUser.query()
            //Show Favorites
            query?.whereKey("app", equalTo: "noir")
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
            self.navTitle.title = "Flirts"
            
            self.UserTableView.reloadData()

            let query = PFUser.query()
            
            query?.whereKey("app", equalTo: "noir")
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
            self.navTitle.title = "Noir"
            
            break
        }
        
        self.activityIndicater.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

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
            cell.ProfilePics.layer.borderColor = ONLINE_COLOR.cgColor
        } else {
            cell.ProfilePics.layer.borderColor = OFFLINE_COLOR.cgColor
            
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
    
    func notification(displayName: String){
        
        let chatNotification = UNMutableNotificationContent()
        chatNotification.title = "Noir Chat Notification"
        chatNotification.subtitle = "You Have a New Chat message from " + displayName
        chatNotification.badge = badge as NSNumber
        chatNotification.sound = .default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier:"Noir", content: chatNotification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func commonActionSheet(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.popoverPresentationController?.sourceView = view
        
        present(alert, animated: true, completion: nil)
    }

}
