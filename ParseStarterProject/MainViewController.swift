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
    
    var subscription: Subscription<PFObject>!
    
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
    
    func setTitleForIndex(index: Int) {
        
        if let label = navigationItem.titleView as? UILabel {
            
            label.text = "\(titles[Int(index)])"
            
        }
        
    }
    
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
        checkMessagesAlert()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            
            self.memberCollectionView.layoutIfNeeded()
        
        }
        
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

        if indexPath.item == 4 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: messagesCellID, for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        geoPoint()
        setTitleForIndex(index: Int(index))
        DispatchQueue.main.async {
            
            self.memberCollectionView.layoutIfNeeded()
            
        }
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        geoPoint()
        setTitleForIndex(index: Int(menuIndex))
        DispatchQueue.main.async {
            
            self.memberCollectionView.layoutIfNeeded()
            
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftanchorConstraint?.constant = scrollView.contentOffset.x / 5
        
        DispatchQueue.main.async {
            
            self.memberCollectionView.layoutIfNeeded()
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        
    }
}
