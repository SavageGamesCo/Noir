//
//  LoginViewController.swift
//  Noir
//
//  Created by Lynx on 2/9/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import Firebase
import GoogleMobileAds
import UserNotifications

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let layout = UICollectionViewFlowLayout()
    let cellID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        setupNavigation(title: "Noir")
        setupMenuBar()
        setupNavBarButtons()
        
        collectionView?.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
        collectionView?.register(MemberCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.isPagingEnabled = true
        if PFUser.current() != nil {
            return
        } else {
           showLogin()
        }
        
        //check for user being logged in
        
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
        let echoIcon = UIImage(named: "games-abstract-7")?.withRenderingMode(.alwaysTemplate)
        let shopIcon = UIImage(named: "shopping-cart-7")?.withRenderingMode(.alwaysTemplate)
        
        let searchBarButtonItem = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: #selector(handleSearch))
        searchBarButtonItem.tintColor = UIColor.white
        let moreBarButtonItem = UIBarButtonItem(image: moreIcon, style: .plain, target: self, action: #selector(handleMore))
        moreBarButtonItem.tintColor = UIColor.white
        let echoBarButtonItem = UIBarButtonItem(image: echoIcon, style: .plain, target: self, action: #selector(handleMore))
        echoBarButtonItem.tintColor = UIColor.white
        let shopBarButtonItem = UIBarButtonItem(image: shopIcon, style: .plain, target: self, action: #selector(handleMore))
        shopBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [moreBarButtonItem, shopBarButtonItem, searchBarButtonItem]
        navigationItem.leftBarButtonItems = []
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    @objc private func handleSearch() {
        
    }
    
    @objc private func handleMore() {
        
    }
    
    private func setupMenuBar(){
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar)
        
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
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MemberCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (view.frame.width - 16 - 16) * 9 / 16
        
        return CGSize(width: view.frame.width, height: height + 16 + 88)
        //        return CGSize(width: view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}
