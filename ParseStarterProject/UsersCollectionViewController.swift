
//
//  UsersCollectionViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit


import GoogleMobileAds


private let reuseIdentifier = "Cell"



class UsersCollectionViewController: UICollectionViewController, UIToolbarDelegate, FetchData {
    
    @IBOutlet var UserTableView: UICollectionView!
    
    @IBOutlet weak var navTitle: UINavigationItem!
    var usernames = [String]()
    var userID = [String]()
    var online = [String]()
    
    var members = [Member]()
    
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
        
        Database.Instance.delegate = self
        
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
    
    func dataReceived(members: [Member]) {
        
        self.members = members
        print("DataReceived")
        
        for member in members {
            if member.userID == Authentication.Instance.userID() {
               Authentication.Instance.username = member.username
            }
        }
        
        UserTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.UserTableView.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
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
            self.navTitle.title = "Global"

            Database.Instance.getMembers()
            
            print(members)

            break
        case "LUser":
            self.navTitle.title = "Local"
            
            Database.Instance.getMembers()

            break
        case "Fave":
            self.navTitle.title = "Favorites"
            
            Database.Instance.getMembers()

            
            break
        case "Flirts":
            self.navTitle.title = "Flirts"
            
            Database.Instance.getMembers()

            
            break
        default:
            self.navTitle.title = "Noir"
            
            Database.Instance.getMembers()
            
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
        return members.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UsersCollectionViewCell
        
        cell.ProfilePics.image = nil
        
        cell.userID = members[indexPath.item].userID
        
        cell.userName.text = members[indexPath.item].username
        
        
//        if online.contains(cell.userID) {
//            cell.ProfilePics.layer.borderColor = onlineColor.cgColor
//        } else {
//            cell.ProfilePics.layer.borderColor = offlineColor.cgColor
//            
//        }
        
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
