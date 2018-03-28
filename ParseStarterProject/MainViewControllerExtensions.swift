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
import Onboard

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
        
        if setting.name == "Profile Settings" {
            let layout = UICollectionViewFlowLayout()
            let profileSettingsViewController = ProfileSettingsViewController(collectionViewLayout: layout)
            profileSettingsViewController.title = setting.name
            profileSettingsViewController.collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
            navigationController?.navigationBar.tintColor = Constants.Colors.NOIR_TINT
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.NOIR_NAV_BAR_TEXT, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
            
            
            navigationController?.pushViewController(profileSettingsViewController, animated: true)
        }
        
        if setting.name == "Privacy Policy & Terms" {
            let layout = UICollectionViewFlowLayout()
            let privacyViewController = TermsPrivacyViewController(collectionViewLayout: layout)
            privacyViewController.title = setting.name
            privacyViewController.collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
            navigationController?.navigationBar.tintColor = Constants.Colors.NOIR_TINT
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.NOIR_NAV_BAR_TEXT, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
            
            
            navigationController?.pushViewController(privacyViewController, animated: true)
        }
        
        if setting.name == "Send Feedback" {
            let layout = UICollectionViewFlowLayout()
            let feedbackViewController = SendFeedbackViewController(collectionViewLayout: layout)
            feedbackViewController.title = setting.name
            feedbackViewController.collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
            navigationController?.navigationBar.tintColor = Constants.Colors.NOIR_TINT
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.NOIR_NAV_BAR_TEXT, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
            
            
            navigationController?.pushViewController(feedbackViewController, animated: true)
        }
        
        if setting.name == "Help Tutorial" {
            
//            let tutorialViewController = TutorialViewController()
//            tutorialViewController.title = setting.name
//            tutorialViewController.view.backgroundColor = Constants.Colors.NOIR_BACKGROUND
            navigationController?.navigationBar.tintColor = Constants.Colors.NOIR_TINT
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.NOIR_NAV_BAR_TEXT, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
            
            
            navigationController?.pushViewController(generateOnboarding(), animated: true)
        }
        
        
    }
    
    func generateOnboarding() -> OnboardingViewController {
        let introPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_INTRO_TITLE, body: Constants.Text.TUTORIAL_INTRO_BODY, image: UIImage(named:"noir_logo_white"), buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let navigationPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_NAVIGATION_TITLE, body: Constants.Text.TUTORIAL_NAVIGATION_BODY, image: nil, buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let membersPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_MEMBER_TITLE, body: Constants.Text.TUTORIAL_MEMBER_BODY, image: nil, buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        
        let memberProfilePage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_MEMBER_PROFILE_TITLE, body: Constants.Text.TUTORIAL_MEMBER_PROFILE_BODY, image: nil, buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let flirtsPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_FLIRTS_TITLE, body: Constants.Text.TUTORIAL_FLIRTS_BODY, image: nil, buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let chatPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_CHAT_TITLE, body: Constants.Text.TUTORIAL_CHAT_BODY, image: nil, buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let settingsPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_SETTINGS_TITLE, body: Constants.Text.TUTORIAL_SETTINGS_BODY, image: nil, buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let echoPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_ECHO_TITLE, body: Constants.Text.TUTORIAL_ECHO_BODY, image: nil, buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let shopPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_SHOP_TITLE, body: Constants.Text.TUTORIAL_SHOP_BODY, image: nil, buttonText: "Continue") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let outroPage = OnboardingContentViewController(title: Constants.Text.TUTORIAL_OUTRO_TITLE, body: Constants.Text.TUTORIAL_OUTRO_BODY, image: nil, buttonText: "Enjoy!") { () -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        
        // Image
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "splash_jpeg"), contents: [introPage, navigationPage, membersPage, memberProfilePage, flirtsPage, chatPage, settingsPage, echoPage, shopPage, outroPage])
//        onboardingVC?.shouldMaskBackground = true
        onboardingVC?.shouldFadeTransitions = true
        onboardingVC?.swipingEnabled = true
        //        onboardingVC?.moveNextPage()
        onboardingVC?.allowSkipping = true
        onboardingVC?.fadeSkipButtonOnLastPage = true
        onboardingVC?.skipHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        
        introPage.movesToNextViewController = true
        introPage.iconImageView.contentMode = .scaleAspectFit
        introPage.iconImageView.clipsToBounds = true
        introPage.topPadding = 20;
        introPage.underIconPadding = 10;
        introPage.underTitlePadding = 15;
        introPage.bottomPadding = 20;
        introPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        introPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        introPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        introPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        navigationPage.movesToNextViewController = true
        navigationPage.iconImageView.contentMode = .scaleAspectFit
        navigationPage.topPadding = 20;
        navigationPage.underIconPadding = 10;
        navigationPage.underTitlePadding = 15;
        navigationPage.bottomPadding = 20;
        navigationPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        navigationPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        navigationPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        navigationPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        membersPage.movesToNextViewController = true
        membersPage.iconImageView.contentMode = .scaleAspectFit
        membersPage.topPadding = 20;
        membersPage.underIconPadding = 10;
        membersPage.underTitlePadding = 15;
        membersPage.bottomPadding = 20;
        membersPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        membersPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        membersPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        membersPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        memberProfilePage.movesToNextViewController = true
        memberProfilePage.iconImageView.contentMode = .scaleAspectFit
        memberProfilePage.topPadding = 20;
        memberProfilePage.underIconPadding = 10;
        memberProfilePage.underTitlePadding = 15;
        memberProfilePage.bottomPadding = 20;
        memberProfilePage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        memberProfilePage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        memberProfilePage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        memberProfilePage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        flirtsPage.movesToNextViewController = true
        flirtsPage.iconImageView.contentMode = .scaleAspectFit
        flirtsPage.topPadding = 20;
        flirtsPage.underIconPadding = 10;
        flirtsPage.underTitlePadding = 15;
        flirtsPage.bottomPadding = 20;
        flirtsPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        flirtsPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        flirtsPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        flirtsPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        chatPage.movesToNextViewController = true
        chatPage.iconImageView.contentMode = .scaleAspectFit
        chatPage.topPadding = 20;
        chatPage.underIconPadding = 10;
        chatPage.underTitlePadding = 15;
        chatPage.bottomPadding = 20;
        chatPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        chatPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        chatPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        chatPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        settingsPage.movesToNextViewController = true
        settingsPage.iconImageView.contentMode = .scaleAspectFit
        settingsPage.topPadding = 20;
        settingsPage.underIconPadding = 10;
        settingsPage.underTitlePadding = 15;
        settingsPage.bottomPadding = 20;
        settingsPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        settingsPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        settingsPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        settingsPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        echoPage.movesToNextViewController = true
        echoPage.iconImageView.contentMode = .scaleAspectFit
        echoPage.topPadding = 20;
        echoPage.underIconPadding = 10;
        echoPage.underTitlePadding = 15;
        echoPage.bottomPadding = 20;
        echoPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        echoPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        echoPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        echoPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        shopPage.movesToNextViewController = true
        shopPage.iconImageView.contentMode = .scaleAspectFit
        shopPage.topPadding = 20;
        shopPage.underIconPadding = 10;
        shopPage.underTitlePadding = 15;
        shopPage.bottomPadding = 20;
        shopPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        shopPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        shopPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        shopPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        outroPage.movesToNextViewController = true
        outroPage.iconImageView.contentMode = .scaleAspectFit
        outroPage.topPadding = 20;
        outroPage.underIconPadding = 10;
        outroPage.underTitlePadding = 15;
        outroPage.bottomPadding = 20;
        outroPage.titleLabel.textColor = Constants.Colors.NOIR_WHITE
        outroPage.bodyLabel.textColor = Constants.Colors.NOIR_WHITE
        outroPage.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        outroPage.bodyLabel.font = UIFont.systemFont(ofSize: 18)
        
        return onboardingVC!
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
        
        
        
    }
    
    
}
