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

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let layout = UICollectionViewFlowLayout()
    let echoCellID = "echoCellId"
    let localCellID = "localCellID"
    let globalCellID = "globalCellID"
    let messagesCellID = "messagesCellID"
    let flirtsCellID = "flirtsCellID"
    let favoritesCellID = "favoritesCellID"
    
    let titles = ["Global", "Local", "Favorites", "Flirts", "Echo", "Messages"]
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.mainViewController = self
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.NOIR_GREY_LIGHT
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        setupCollectionView()
        setupNavigation(title: "Noir")
        setupMenuBar()
        setupNavBarButtons()
        
        //Check if user is already logged in
        if PFUser.current() != nil {
            
            APIService.sharedInstance.validateAppleReciepts()
            

        } else {
            showLogin()
        }

        
        
    }
    
    func setupCollectionView(){
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            
        }
        collectionView?.backgroundColor = Constants.Colors.NOIR_GREY_LIGHT
        collectionView?.register(GlobalCell.self, forCellWithReuseIdentifier: globalCellID)
        collectionView?.register(LocalCell.self, forCellWithReuseIdentifier: localCellID)
        collectionView?.register(EchoCell.self, forCellWithReuseIdentifier: echoCellID)
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
        titleLabel.textColor = UIColor.white
//        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
    
    private func setupNavBarButtons(){
        
        let searchIcon = UIImage(named: "search-7")?.withRenderingMode(.alwaysTemplate)
        let moreIcon = UIImage(named: "dot-more-7")?.withRenderingMode(.alwaysTemplate)
        let shopIcon = UIImage(named: "shopping-cart-7")?.withRenderingMode(.alwaysTemplate)
        
        let searchBarButtonItem = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: #selector(handleSearch))
        searchBarButtonItem.tintColor = UIColor.white
        let moreBarButtonItem = UIBarButtonItem(image: moreIcon, style: .plain, target: self, action: #selector(handleMore))
        moreBarButtonItem.tintColor = UIColor.white
        let shopBarButtonItem = UIBarButtonItem(image: shopIcon, style: .plain, target: self, action: #selector(handleShop))
        shopBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [moreBarButtonItem, shopBarButtonItem, searchBarButtonItem]
        navigationItem.leftBarButtonItems = []
    }
    
    @objc private func handleSearch() {
        showLogin()
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        setTitleForIndex(index: Int(index))
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        setTitleForIndex(index: Int(menuIndex))
         
    }
    
    @objc private func handleShop() {
        
    }

    @objc private func handleMore() {
//        let settingsLauncher = SettingsLauncher()
//        settingsLauncher.showSettings()
        print("SETUP MORE CLICKED")
    }
    
    
    private func setupMenuBar(){
        navigationController?.hidesBarsOnSwipe = true
        
        let hiderView = UIView()
        hiderView.backgroundColor = Constants.Colors.NOIR_GREY_MEDIUM
        view.addSubview(hiderView)
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: hiderView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: hiderView)
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftanchorConstraint?.constant = scrollView.contentOffset.x / 6
        print(scrollView.contentOffset.x)
    }
    
    private func setTitleForIndex(index: Int) {
        if let label = navigationItem.titleView as? UILabel {
            label.text = "\(titles[Int(index)])"
        }
    }
    
    @objc private func handleLogout(){
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        print("logout pressed")
    }
    
    private func showLogin(){
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
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
            return collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath)
        }

        if indexPath.item == 5 {
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
