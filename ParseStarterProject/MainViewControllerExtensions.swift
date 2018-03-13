//
//  MainViewControllerExtensions.swift
//  Noir
//
//  Created by Lynx on 3/13/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import Firebase
import GoogleMobileAds
import UserNotifications
import AVFoundation

extension MainViewController {
    
    func setupMenuBar(){
        
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
    
    func showControllerForSettings(setting: Setting) {
        let layout = UICollectionViewFlowLayout()
        let profileSettingsViewController = ProfileSettingsViewController(collectionViewLayout: layout)
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
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0)
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
    
    func setupNavBarButtons(){
        
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
                
                //                let cell = self.menuBar.collectionView.cellForItem(at: IndexPath(item: 5, section: 0)) as! MenuCell
                //                self.collectionView?.reloadData()
                
                
                // create a sound ID, in this case its the tweet sound.
                let systemSoundID: SystemSoundID = 1322
                
                // to play sound
                AudioServicesPlaySystemSound (systemSoundID)
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
            }
            
        }
        
    }
    
    @objc func handleLogout(){
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    func showLogin(){
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    @objc func handleShop() {
        
    }
    
    
    @objc func handleMore() {
        
        settingsView.showSettings()
        
    }
    
    @objc func handleSearch() {
        
        showLogin()
        
    }
    
    
}
