//
//  LoginViewController.swift
//  Noir
//
//  Created by Lynx on 2/9/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import Firebase
import GoogleMobileAds
import UserNotifications
import AVFoundation

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let layout = UICollectionViewFlowLayout()
    let echoCellID = "echoCellId"
    let localCellID = "localCellID"
    let globalCellID = "globalCellID"
    let messagesCellID = "messagesCellID"
    let flirtsCellID = "flirtsCellID"
    let favoritesCellID = "favoritesCellID"
    
    let titles = ["Noir: Global Members", "Noir: Local Members", "Noir: Favorites", "Noir: Received Flirts", "Noir: Messages"]
    
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    
    private var subscription: Subscription<PFObject>!
    
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.mainViewController = self
        return mb
    }()
    
    lazy var memberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        setupCollectionView()
        setupNavigation(title: "Noir")
        setupMenuBar()
        setupNavBarButtons()
        geoPoint()
        APIService.sharedInstance.validateAppleReciepts()
        
//        memberCollectionView.reloadData()

    }
    
    func setupCollectionView(){
        navigationController?.hidesBarsOnSwipe = true
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            
        }
        collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        collectionView?.register(GlobalCell.self, forCellWithReuseIdentifier: globalCellID)
        collectionView?.register(LocalCell.self, forCellWithReuseIdentifier: localCellID)
//        collectionView?.register(EchoCell.self, forCellWithReuseIdentifier: echoCellID)
        collectionView?.register(FavoritesCell.self, forCellWithReuseIdentifier: favoritesCellID)
        collectionView?.register(FlirtsCell.self, forCellWithReuseIdentifier: flirtsCellID)
        collectionView?.register(MessagesCell.self, forCellWithReuseIdentifier: messagesCellID)
        collectionView?.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, 0, 0)
        collectionView?.isPagingEnabled = true
    }
    
    func setupNavigation(title: String){
        navigationItem.title = title
        
        navigationController?.navigationBar.isTranslucent = false
        
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height ))
        titleLabel.text = title
        titleLabel.textColor = Constants.Colors.NOIR_NAV_BAR_TEXT

        navigationItem.titleView = titleLabel
    }
    
    private func setupNavBarButtons(){
        
        let searchIcon = UIImage(named: "search-7")?.withRenderingMode(.alwaysTemplate)
        let moreIcon = UIImage(named: "dot-more-7")?.withRenderingMode(.alwaysTemplate)
        let shopIcon = UIImage(named: "shopping-cart-7")?.withRenderingMode(.alwaysTemplate)
        
        let searchBarButtonItem = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: #selector(handleSearch))
        searchBarButtonItem.tintColor = Constants.Colors.NOIR_TINT
        let moreBarButtonItem = UIBarButtonItem(image: moreIcon, style: .plain, target: self, action: #selector(handleMore))
        moreBarButtonItem.tintColor = Constants.Colors.NOIR_TINT
        let shopBarButtonItem = UIBarButtonItem(image: shopIcon, style: .plain, target: self, action: #selector(handleShop))
        shopBarButtonItem.tintColor = Constants.Colors.NOIR_TINT
        navigationItem.rightBarButtonItems = [moreBarButtonItem, shopBarButtonItem, searchBarButtonItem]
        navigationItem.leftBarButtonItems = []
    }
    
    func geoPoint(){
        
        PFGeoPoint.geoPointForCurrentLocation(inBackground: {(geopoint, error) in
            
            if let geopoint = geopoint {
                PFUser.current()?["location"] = geopoint
                PFUser.current()?.saveInBackground()
                
            }
        })
    }
    
    func checkMessagesAlert(){
        let msgQuery = PFQuery(className: "Chat").whereKey("app", equalTo: APPLICATION).whereKey("toUser", contains: CURRENT_USER!)
        
        subscription = liveQueryClient.subscribe(msgQuery).handle(Event.created) { _, message in
            // This is where we handle the event
            
            DispatchQueue.main.async {
                
                let cell = self.menuBar.collectionView.cellForItem(at: IndexPath(item: 5, section: 0))
                
                cell?.tintColor = Constants.Colors.NOIR_GREEN
                
                // import this
                
                
                // create a sound ID, in this case its the tweet sound.
                let systemSoundID: SystemSoundID = 1322
                
                // to play sound
                AudioServicesPlaySystemSound (systemSoundID)
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
            }
            
        }
        
    }
    
    @objc private func handleSearch() {
        showLogin()
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        geoPoint()
        setTitleForIndex(index: Int(index))
        DispatchQueue.main.async {
//            self.memberCollectionView.reloadData()
//            self.memberCollectionView.setNeedsDisplay()
            
        }
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        geoPoint()
        setTitleForIndex(index: Int(menuIndex))
        DispatchQueue.main.async {
//            self.memberCollectionView.setNeedsDisplay()
//            self.memberCollectionView.reloadData()
        }
         
    }
    
    @objc private func handleShop() {
        
    }

    lazy var settingsView: SettingsLauncher = {
        let sv = SettingsLauncher()
        sv.mainViewController = self
        return sv
    }()
    
    lazy var detailsView: UserDetailsLauncher = {
        let dv = UserDetailsLauncher()
        dv.mainViewController = self
        return dv
    }()
    
    @objc func handleMore() {
        
        settingsView.showSettings()
    }
    
    func showControllerForSettings(setting: Setting) {
        
        let profileSettingsViewController = UIViewController()
        profileSettingsViewController.title = setting.name
        navigationController?.navigationBar.tintColor = Constants.Colors.NOIR_TINT
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.NOIR_NAV_BAR_TEXT, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        
        
        navigationController?.pushViewController(profileSettingsViewController, animated: true)
       
    }
    
    func showControllerForDetails(detail: Detail) {
        
        let profileSettingsViewController = UIViewController()
        profileSettingsViewController.title = detail.label
        navigationController?.navigationBar.tintColor = Constants.Colors.NOIR_TINT
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.NOIR_NAV_BAR_TEXT, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        
        
        navigationController?.pushViewController(profileSettingsViewController, animated: true)
        
    }
    
    
    private func setupMenuBar(){
        
        let hiderView = UIView()
        hiderView.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        view.addSubview(hiderView)
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: hiderView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: hiderView)
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftanchorConstraint?.constant = scrollView.contentOffset.x / 5
        DispatchQueue.main.async {
//                        self.memberCollectionView.reloadData()
//                        self.memberCollectionView.setNeedsDisplay()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.memberCollectionView.reloadData()
            //                                        self.memberCollectionView.setNeedsDisplay()
            
        }
    }
    
    private func setTitleForIndex(index: Int) {
        
        if let label = navigationItem.titleView as? UILabel {
            label.text = "\(titles[Int(index)])"
            
            
        }
    }
    
    @objc private func handleLogout(){
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    private func showLogin(){
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if indexPath.item == 0 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: globalCellID, for: indexPath)
        }
        
        if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: localCellID, for: indexPath)
        }

        if indexPath.item == 2 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: favoritesCellID, for: indexPath)
        }

        if indexPath.item == 3 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: flirtsCellID, for: indexPath)
        }
//        if indexPath.item == 4 {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath)
//        }

        if indexPath.item == 4 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: messagesCellID, for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    override func didReceiveMemoryWarning() {
        
    }
}
